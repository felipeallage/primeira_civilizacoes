-- Query 4.1 — Total de interações por civilização
-- Conceito: UNION + Subquery + GROUP BY
-- Objetivo: contar todas as interações de cada civilização
--           independente de ser civ_a ou civ_b

SELECT
    c.name                          AS civilizacao,
    c.social_complexity_score       AS complexidade_social,
    COUNT(i.id)                     AS total_interacoes
FROM civilizations c
JOIN (
    -- Subquery: une interações como civ_a e como civ_b
    SELECT id, civ_a_id AS civilization_id FROM interactions
    UNION ALL
    SELECT id, civ_b_id AS civilization_id FROM interactions
) i ON i.civilization_id = c.id
GROUP BY c.id, c.name, c.social_complexity_score
ORDER BY total_interacoes DESC, complexidade_social DESC;-- Query 4.2 — Tipo de interação dominante por civilização
-- Conceito: Subquery + CASE WHEN
-- Objetivo: identificar o tipo de interação predominante
--           de cada civilização

WITH todas_interacoes AS (
    -- Subquery: une interações como civ_a e como civ_b
    SELECT civ_a_id AS civilization_id, interaction_type FROM interactions
    UNION ALL
    SELECT civ_b_id AS civilization_id, interaction_type FROM interactions
),
contagem_por_tipo AS (
    -- CTE: conta cada tipo de interação por civilização
    SELECT
        civilization_id,
        interaction_type,
        COUNT(*)                                AS total
    FROM todas_interacoes
    GROUP BY civilization_id, interaction_type
),
tipo_dominante AS (
    -- CTE: seleciona o tipo com maior contagem por civilização
    SELECT DISTINCT ON (civilization_id)
        civilization_id,
        interaction_type                        AS tipo_dominante,
        total                                   AS total_tipo_dominante
    FROM contagem_por_tipo
    ORDER BY civilization_id, total DESC
)
SELECT
    c.name                                      AS civilizacao,
    c.social_complexity_score                   AS complexidade_social,
    td.tipo_dominante,
    td.total_tipo_dominante,
    CASE
        WHEN td.tipo_dominante = 'comércio'  THEN 'expansão econômica'
        WHEN td.tipo_dominante = 'cultural'  THEN 'difusão intelectual'
        WHEN td.tipo_dominante = 'guerra'    THEN 'expansão territorial'
    END                                         AS perfil_de_interacao
FROM civilizations c
JOIN tipo_dominante td ON td.civilization_id = c.id
ORDER BY c.social_complexity_score DESC;-- Query 4.3 — Correlação entre interações e complexidade social
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