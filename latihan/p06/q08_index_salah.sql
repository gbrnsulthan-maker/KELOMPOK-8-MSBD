-- Diminta: mengukur query yang sama dengan index berurutan kolom tidak cocok (terjadi_pada, customer_id).
-- Dipilih: CREATE INDEX ev_salah_idx lalu EXPLAIN (ANALYZE, BUFFERS) untuk melihat apakah Sort masih muncul.
-- Alternatif: membiarkan baseline tanpa index; tidak dipilih karena inti soal justru membandingkan pengaruh urutan kolom.
SET max_parallel_workers_per_gather = 0;
CREATE INDEX IF NOT EXISTS ev_salah_idx
ON lab6.event_log (terjadi_pada, customer_id);

EXPLAIN (ANALYZE, BUFFERS)
SELECT event_id, jumlah
FROM lab6.event_log
WHERE customer_id = 4211
  AND terjadi_pada >= timestamptz '2024-06-01 00:00+07'
ORDER BY terjadi_pada DESC
LIMIT 20;
