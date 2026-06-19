-- Query 5.2 — Score final ponderado
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