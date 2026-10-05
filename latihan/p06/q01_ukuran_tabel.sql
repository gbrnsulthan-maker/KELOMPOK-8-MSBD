-- Q1 - Ukuran Tabel

-- Jumlah baris
SELECT count(*) AS jumlah_baris
FROM lab6.event_log;

-- Ukuran total tabel
SELECT
    pg_total_relation_size('lab6.event_log') AS ukuran_total_bytes,
    pg_size_pretty(pg_total_relation_size('lab6.event_log')) AS ukuran_total;

-- Rata-rata byte per baris
SELECT
    pg_total_relation_size('lab6.event_log')::numeric
    / count(*) AS rata_rata_byte_per_baris
FROM lab6.event_log;

-- Detail ukuran heap dan TOAST
SELECT
    pg_relation_size('lab6.event_log') AS heap_bytes,
    pg_size_pretty(pg_relation_size('lab6.event_log')) AS heap_size,
    pg_total_relation_size('lab6.event_log') AS total_bytes,
    pg_size_pretty(pg_total_relation_size('lab6.event_log')) AS total_size;