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
ORDER BY total_interacoes DESC, complexidade_social DESC;