-- Query 1.2 — Clima e complexidade social
-- Conceito: JOIN + AVG + GROUP BY
-- Objetivo: verificar se zona climática influencia
--           o nível médio de complexidade social

SELECT
    g.climate_zone                          AS zona_climatica,
    COUNT(c.id)                             AS total_civilizacoes,
    ROUND(AVG(c.social_complexity_score),2) AS complexidade_media,
    ROUND(AVG(c.peak_population),0)         AS populacao_media_no_auge
FROM civilizations c
JOIN geographies g ON g.civilization_id = c.id
GROUP BY g.climate_zone
ORDER BY complexidade_media DESC;