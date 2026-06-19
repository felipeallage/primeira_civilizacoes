-- Query 2.2 — Ranking complexidade vs perfil de recursos
-- Conceito: CTE + CASE WHEN + ORDER BY
-- Objetivo: classificar cada civilização pelo perfil de recursos
--           e verificar correlação com complexidade social

WITH perfil_recursos AS (
    -- CTE: conta recursos por nível de abundância para cada civilização
    SELECT
        civilization_id,
        COUNT(*) FILTER (WHERE abundance = 'alta')  AS recursos_altos,
        COUNT(*) FILTER (WHERE abundance = 'média') AS recursos_medios,
        COUNT(*) FILTER (WHERE abundance = 'baixa') AS recursos_baixos,
        COUNT(*)                                     AS total_recursos
    FROM resources
    GROUP BY civilization_id
)
SELECT
    c.name                          AS civilizacao,
    c.social_complexity_score       AS complexidade_social,
    pr.recursos_altos,
    pr.recursos_medios,
    pr.total_recursos,
    CASE
        WHEN pr.recursos_altos >= 3 THEN 'rico'
        WHEN pr.recursos_altos >= 2 THEN 'moderado'
        ELSE                             'limitado'
    END                             AS perfil_de_recursos,
    RANK() OVER (
        ORDER BY c.social_complexity_score DESC
    )                               AS rank_complexidade
FROM civilizations c
JOIN perfil_recursos pr ON pr.civilization_id = c.id
ORDER BY rank_complexidade;