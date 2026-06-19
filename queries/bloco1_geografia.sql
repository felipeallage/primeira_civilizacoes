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
ORDER BY g.near_river DESC, c.social_complexity_score DESC;-- Query 1.2 — Clima e complexidade social
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
ORDER BY complexidade_media DESC;-- Query 1.3 — Altitude, litoral e complexidade social
-- Conceito: CASE WHEN + JOIN + AVG + GROUP BY
-- Objetivo: verificar se acesso ao litoral e faixa de altitude
--           influenciam o nível de complexidade social

SELECT
    CASE
        WHEN g.coastal = true THEN 'costeira'
        ELSE 'interior'
    END                                         AS tipo_localizacao,

    CASE
        WHEN g.elevation_m < 100  THEN 'baixa (< 100m)'
        WHEN g.elevation_m < 300  THEN 'média (100–300m)'
        ELSE                           'alta (> 300m)'
    END                                         AS faixa_altitude,

    COUNT(c.id)                                 AS total_civilizacoes,
    ROUND(AVG(c.social_complexity_score), 2)    AS complexidade_media,
    STRING_AGG(c.name, ', ')                    AS civilizacoes

FROM civilizations c
JOIN geographies g ON g.civilization_id = c.id
GROUP BY tipo_localizacao, faixa_altitude
ORDER BY complexidade_media DESC;