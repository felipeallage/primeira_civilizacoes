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
ORDER BY total_marcos DESC, complexidade_social DESC;-- Query 3.2 — Tempo até o primeiro marco
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
ORDER BY anos_ate_primeiro_marco ASC;-- Query 3.3 — Densidade de marcos por século
-- Conceito: RANK() + Window function
-- Objetivo: calcular a densidade de marcos por século
--           e rankear civilizações por velocidade de desenvolvimento

WITH duracao_e_marcos AS (
    -- CTE: calcula duração e total de marcos por civilização
    SELECT
        c.id,
        c.name                                          AS civilizacao,
        c.social_complexity_score                       AS complexidade_social,
        c.start_year,
        c.end_year,
        (c.end_year - c.start_year)                     AS duracao_anos,
        COUNT(m.id)                                     AS total_marcos
    FROM civilizations c
    LEFT JOIN milestones m ON m.civilization_id = c.id
    GROUP BY c.id, c.name, c.social_complexity_score,
             c.start_year, c.end_year
)
SELECT
    civilizacao,
    duracao_anos                                        AS duração_anos,
    total_marcos,
    ROUND(
        (total_marcos::NUMERIC / duracao_anos) * 100, 4
    )                                                   AS marcos_por_seculo,
    complexidade_social,
    RANK() OVER (
        ORDER BY
            (total_marcos::NUMERIC / duracao_anos) DESC
    )                                                   AS rank_velocidade
FROM duracao_e_marcos
ORDER BY rank_velocidade;