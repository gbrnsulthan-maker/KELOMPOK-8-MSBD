-- Diminta: mengukur baseline query utama TANPA index apa pun, 3 kali jalan.
-- Dipilih: EXPLAIN (ANALYZE, BUFFERS) karena menampilkan rencana nyata, baris aktual, dan jumlah page yang dibaca.
-- Alternatif: \timing saja; tidak dipilih karena tidak menunjukkan node rencana dan Buffers.
SET max_parallel_workers_per_gather = 0;
EXPLAIN (ANALYZE, BUFFERS)
SELECT event_id, jumlah
FROM lab6.event_log
WHERE customer_id = 4211
  AND terjadi_pada >= timestamptz '2024-06-01 00:00+07'
ORDER BY terjadi_pada DESC
LIMIT 20;
