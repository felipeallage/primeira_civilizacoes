-- Query 2.3 — Tipos de recurso nas civilizações mais complexas
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