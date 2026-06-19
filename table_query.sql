
SELECT 'civilizations' AS tabela, COUNT(*) AS registros FROM civilizations
UNION ALL
SELECT 'geographies',  COUNT(*) FROM geographies
UNION ALL
SELECT 'resources',    COUNT(*) FROM resources
UNION ALL
SELECT 'milestones',   COUNT(*) FROM milestones
UNION ALL
SELECT 'interactions', COUNT(*) FROM interactions;