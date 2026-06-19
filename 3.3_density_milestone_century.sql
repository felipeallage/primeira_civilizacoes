-- Query 3.3 — Densidade de marcos por século
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