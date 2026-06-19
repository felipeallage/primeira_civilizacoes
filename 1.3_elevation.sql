-- Query 1.3 — Altitude, litoral e complexidade social
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