-- Query 4.2 — Tipo de interação dominante por civilização
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
ORDER BY c.social_complexity_score DESC;