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
ORDER BY v.social_complexity_score DESC;