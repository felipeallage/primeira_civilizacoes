-- Query 3.1 — Total de marcos por civilização
-- Conceito: JOIN + GROUP BY + COUNT
-- Objetivo: contar quantos marcos cada civilização acumulou
--           e quais tipos foram mais registrados

SELECT
    c.name                                      AS civilizacao,
    c.social_complexity_score                   AS complexidade_social,
    COUNT(m.id)                                 AS total_marcos,
    COUNT(DISTINCT m.milestone_type)            AS tipos_distintos,
    STRING_AGG(DISTINCT m.milestone_type, ', '
        ORDER BY m.milestone_type)              AS tipos_de_marco
FROM civilizations c
LEFT JOIN milestones m ON m.civilization_id = c.id
GROUP BY c.id, c.name, c.social_complexity_score
ORDER BY total_marcos DESC, complexidade_social DESC;