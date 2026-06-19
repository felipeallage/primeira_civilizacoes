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
ORDER BY recursos_abundantes DESC, complexidade_social DESC;