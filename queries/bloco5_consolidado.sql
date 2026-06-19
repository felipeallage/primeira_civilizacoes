-- Query 5.1 — Painel comparativo completo
-- Conceito: View + LEFT JOIN + agregações compostas
-- Objetivo: consolidar todas as dimensões analisadas
--           em uma visão única por civilização

WITH recursos_resumo AS (
    SELECT
        civilization_id,
        COUNT(*) FILTER (WHERE abundance = 'alta')  AS recursos_altos,
        COUNT(*)                                     AS total_recursos
    FROM resources
    GROUP BY civilization_id
),
marcos_resumo AS (
    SELECT
        civilization_id,
        COUNT(*)                                     AS total_marcos
    FROM milestones
    GROUP BY civilization_id
),
interacoes_resumo AS (
    SELECT civilization_id, COUNT(id) AS total_interacoes
    FROM (
        SELECT id, civ_a_id AS civilization_id FROM interactions
        UNION ALL
        SELECT id, civ_b_id AS civilization_id FROM interactions
    ) todas
    GROUP BY civilization_id
)
SELECT
    -- Identidade
    v.name                                          AS civilizacao,
    v.region                                        AS regiao,
    v.start_year                                    AS surgimento,
    (v.end_year - v.start_year)                     AS duracao_anos,

    -- Complexidade
    v.social_complexity_score                       AS complexidade_social,
    v.government_type                               AS governo,
    v.writing_system                                AS tinha_escrita,

    -- Geografia
    v.climate_zone                                  AS clima,
    v.near_river                                    AS proximo_rio,
    v.coastal                                       AS costeira,
    v.elevation_m                                   AS altitude_m,

    -- Recursos
    COALESCE(rr.recursos_altos, 0)                  AS recursos_altos,
    COALESCE(rr.total_recursos, 0)                  AS total_recursos,

    -- Marcos
    COALESCE(mr.total_marcos, 0)                    AS total_marcos,

    -- Interações
    COALESCE(ir.total_interacoes, 0)                AS total_interacoes,

    -- Classificações
    CASE
        WHEN v.social_complexity_score >= 9.0 THEN 'elite'
        WHEN v.social_complexity_score >= 7.5 THEN 'avançada'
        ELSE                                        'emergente'
    END                                             AS tier_complexidade

FROM vw_civilization_overview v
LEFT JOIN recursos_resumo   rr ON rr.civilization_id = v.id
LEFT JOIN marcos_resumo     mr ON mr.civilization_id = v.id
LEFT JOIN interacoes_resumo ir ON ir.civilization_id = v.id
ORDER BY v.social_complexity_score DESC;-- Query 5.2 — Score final ponderado
-- Conceito: CTE + CASE WHEN + RANK() + agregações compostas
-- Objetivo: construir um score composto que cruza todas
--           as dimensões analisadas e comparar com
--           o social_complexity_score original

WITH dimensoes AS (
    -- CTE: consolida todas as dimensões por civilização
    SELECT
        c.id,
        c.name                                          AS civilizacao,
        c.social_complexity_score                       AS complexidade_original,

        -- Dimensão 1: geografia (rio + litoral + clima)
        CASE WHEN g.near_river  = true THEN 2 ELSE 0 END +
        CASE WHEN g.coastal     = true THEN 1 ELSE 0 END +
        CASE
            WHEN g.climate_zone = 'mediterrâneo'    THEN 3
            WHEN g.climate_zone = 'árido'           THEN 2
            WHEN g.climate_zone = 'temperado'       THEN 2
            WHEN g.climate_zone = 'tropical'        THEN 1
            ELSE                                         1
        END                                             AS score_geografia,

        -- Dimensão 2: recursos
        COUNT(r.id) FILTER (WHERE r.abundance = 'alta')  * 2 +
        COUNT(r.id) FILTER (WHERE r.abundance = 'média') * 1
                                                        AS score_recursos,

        -- Dimensão 3: marcos
        COUNT(DISTINCT m.id)                            AS score_marcos,

        -- Dimensão 4: interações
        COUNT(DISTINCT CASE
            WHEN i.civ_a_id = c.id THEN i.id
            WHEN i.civ_b_id = c.id THEN i.id
        END)                                            AS score_interacoes,

        -- Dimensão 5: escrita
        CASE WHEN c.writing_system = true THEN 2 ELSE 0 END
                                                        AS score_escrita

    FROM civilizations c
    LEFT JOIN geographies g  ON g.civilization_id  = c.id
    LEFT JOIN resources r    ON r.civilization_id   = c.id
    LEFT JOIN milestones m   ON m.civilization_id   = c.id
    LEFT JOIN interactions i ON i.civ_a_id = c.id
                             OR i.civ_b_id = c.id
    GROUP BY c.id, c.name, c.social_complexity_score,
             g.near_river, g.coastal, g.climate_zone,
             c.writing_system
)
SELECT
    civilizacao,
    complexidade_original,
    score_geografia,
    score_recursos,
    score_marcos,
    score_interacoes,
    score_escrita,
    (score_geografia +
     score_recursos  +
     score_marcos    +
     score_interacoes+
     score_escrita)                                     AS score_composto,
    RANK() OVER (
        ORDER BY complexidade_original DESC
    )                                                   AS rank_original,
    RANK() OVER (
        ORDER BY (score_geografia +
                  score_recursos  +
                  score_marcos    +
                  score_interacoes+
                  score_escrita) DESC
    )                                                   AS rank_composto,
    RANK() OVER (
        ORDER BY complexidade_original DESC
    ) -
    RANK() OVER (
        ORDER BY (score_geografia +
                  score_recursos  +
                  score_marcos    +
                  score_interacoes+
                  score_escrita) DESC
    )                                                   AS diferenca_ranks
FROM dimensoes
ORDER BY rank_composto;