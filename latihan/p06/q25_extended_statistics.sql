-- Q25: Extended Statistics wilayah-kota

SET max_parallel_workers_per_gather = 0;

-- Kondisi sebelum extended statistics
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE wilayah = 'SUMATERA UTARA'
  AND kota = 'Medan';

-- Membuat extended statistics
CREATE STATISTICS ev_wilayah_kota_stat
    (dependencies, ndistinct, mcv)
ON wilayah, kota
FROM lab6.event_log;

-- Perbarui statistik
ANALYZE lab6.event_log;

-- Kondisi setelah extended statistics
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE wilayah = 'SUMATERA UTARA'
  AND kota = 'Medan';

-- Lihat statistik kolom
SELECT
    tablename,
    attname,
    n_distinct,
    most_common_vals,
    most_common_freqs,
    correlation
FROM pg_stats
WHERE schemaname = 'lab6'
  AND tablename = 'event_log'
  AND attname IN ('wilayah', 'kota');