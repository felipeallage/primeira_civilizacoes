-- Query 1.1 — Rios e complexidade social
-- Conceito: JOIN entre civilizations e geographies + ORDER BY
-- Objetivo: verificar se proximidade a rios se correlaciona
--           com maior complexidade social

SELECT
    c.name                      AS civilizacao,
    c.region                    AS regiao,
    g.near_river                AS proximo_a_rio,
    g.river_name                AS rio,
    c.social_complexity_score   AS complexidade_social
FROM civilizations c
JOIN geographies g ON g.civilization_id = c.id
ORDER BY g.near_river DESC, c.social_complexity_score DESC;