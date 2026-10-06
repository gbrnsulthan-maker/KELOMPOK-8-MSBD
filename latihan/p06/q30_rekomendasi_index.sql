-- Q30: Rekomendasi index

-- event_log_pkey
-- Keputusan: KEEP
-- Alasan: primary key dan idx_scan = 7.
-- Ukuran index: 43 MB.

-- ev_status_idx
-- Keputusan: KEEP
-- Alasan: idx_scan = 20 dan digunakan pada query status.
-- Ukuran index: 13 MB.

SELECT
    indexrelname AS index_name,
    idx_scan,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'lab6'
  AND relname = 'event_log'
ORDER BY indexrelname;