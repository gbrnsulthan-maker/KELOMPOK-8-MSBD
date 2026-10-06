-- Q22: Index pada kolom status

-- Matikan parallel worker untuk pengukuran
SET max_parallel_workers_per_gather = 0;

-- Buat index status
CREATE INDEX IF NOT EXISTS ev_status_idx
ON lab6.event_log (status);

-- Pastikan statistik terbaru
ANALYZE lab6.event_log;

-- Uji status SUKSES
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'SUKSES';

-- Uji status GAGAL
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'GAGAL';