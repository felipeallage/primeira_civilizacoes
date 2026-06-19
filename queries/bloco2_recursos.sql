-- Query 2.1 — Recursos abundantes por civilização
-- Conceito: CTE + JOIN + GROUP BY
-- Objetivo: contar quantos recursos de abundância "alta"
--           cada civilização possuía

WITH recursos_altos AS (
    -- CTE: filtra apenas recursos com abundância alta
    SELECT
        civilization_id,
        COUNT(*) AS total_recursos_altos
    FROM resources
    WHERE abundance = 'alta'
    GROUP BY civilization_id
)
SELECT
    c.name                          AS civilizacao,
    c.social_complexity_score       AS complexidade_social,
    COALESCE(ra.total_recursos_altos, 0) AS recursos_abundantes
FROM civilizations c
LEFT JOIN recursos_altos ra ON ra.civilization_id = c.id
ORDER BY recursos_abundantes DESC, complexidade_social DESC;-- Query 2.2 — Ranking complexidade vs perfil de recursos
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
ORDER BY rank_complexidade;-- Query 2.3 — Tipos de recurso nas civilizações mais complexas
-- Conceito: JOIN + GROUP BY + CASE WHEN
-- Objetivo: identificar quais tipos de recurso dominam
--           nas civilizações de maior complexidade social

SELECT
    r.resource_type                         AS tipo_recurso,
    COUNT(*)                                AS total_civilizacoes,
    ROUND(AVG(c.social_complexity_score),2) AS complexidade_media,
    STRING_AGG(c.name, ', ' ORDER BY c.social_complexity_score DESC) AS civilizacoes,
    CASE
        WHEN AVG(c.social_complexity_score) >= 8.5 THEN 'alto impacto'
        WHEN AVG(c.social_complexity_score) >= 7.0 THEN 'médio impacto'
        ELSE                                            'baixo impacto'
    END                                     AS impacto_na_complexidade
FROM resources r
JOIN civilizations c ON c.id = r.civilization_id
GROUP BY r.resource_type
ORDER BY complexidade_media DESC;