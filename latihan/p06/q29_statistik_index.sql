-- Q29: Statistik penggunaan index

SELECT
    indexrelname AS index_name,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'lab6'
  AND relname = 'event_log'
ORDER BY pg_relation_size(indexrelid) DESC;