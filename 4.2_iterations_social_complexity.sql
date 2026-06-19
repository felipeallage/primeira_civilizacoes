-- Query 4.3 — Correlação entre interações e complexidade social
-- Conceito: Subquery + JOIN + RANK() Window function
-- Objetivo: cruzar rank de interações com rank de complexidade
--           para identificar correlação entre conectividade e desenvolvimento

WITH total_interacoes AS (
    -- Subquery: conta total de interações por civilização
    SELECT
        civilization_id,
        COUNT(id)                               AS total_interacoes
    FROM (
        SELECT id, civ_a_id AS civilization_id FROM interactions
        UNION ALL
        SELECT id, civ_b_id AS civilization_id FROM interactions
    ) todas
    GROUP BY civilization_id
)
SELECT
    c.name                                      AS civilizacao,
    c.social_complexity_score                   AS complexidade_social,
    COALESCE(ti.total_interacoes, 0)            AS total_interacoes,
    RANK() OVER (
        ORDER BY c.social_complexity_score DESC
    )                                           AS rank_complexidade,
    RANK() OVER (
        ORDER BY COALESCE(ti.total_interacoes, 0) DESC
    )                                           AS rank_interacoes,
    RANK() OVER (
        ORDER BY c.social_complexity_score DESC
    ) -
    RANK() OVER (
        ORDER BY COALESCE(ti.total_interacoes, 0) DESC
    )                                           AS diferenca_ranks
FROM civilizations c
LEFT JOIN total_interacoes ti ON ti.civilization_id = c.id
ORDER BY rank_complexidade;