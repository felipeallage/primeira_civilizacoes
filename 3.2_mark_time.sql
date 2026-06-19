-- Query 3.2 — Tempo até o primeiro marco
-- Conceito: Window function + MIN + JOIN
-- Objetivo: calcular quanto tempo cada civilização levou
--           desde seu surgimento até seu primeiro marco registrado

WITH primeiro_marco AS (
    -- CTE: encontra o marco mais antigo de cada civilização
    SELECT
        civilization_id,
        MIN(year)                               AS ano_primeiro_marco,
        FIRST_VALUE(milestone_type) OVER (
            PARTITION BY civilization_id
            ORDER BY year ASC
        )                                       AS tipo_primeiro_marco
    FROM milestones
    GROUP BY civilization_id, milestone_type, year
),
primeiro_por_civ AS (
    -- CTE: garante um registro por civilização
    SELECT DISTINCT ON (civilization_id)
        civilization_id,
        ano_primeiro_marco,
        tipo_primeiro_marco
    FROM primeiro_marco
    ORDER BY civilization_id, ano_primeiro_marco ASC
)
SELECT
    c.name                                      AS civilizacao,
    c.start_year                                AS ano_surgimento,
    p.ano_primeiro_marco                        AS ano_primeiro_marco,
    p.tipo_primeiro_marco                       AS tipo_primeiro_marco,
    (p.ano_primeiro_marco - c.start_year)       AS anos_ate_primeiro_marco,
    c.social_complexity_score                   AS complexidade_social
FROM civilizations c
JOIN primeiro_por_civ p ON p.civilization_id = c.id
ORDER BY anos_ate_primeiro_marco ASC;