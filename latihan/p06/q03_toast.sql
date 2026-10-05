-- Q3 - TOAST

SELECT
    attname AS kolom,
    attstorage AS storage
FROM pg_attribute
WHERE attrelid = 'lab6.event_log'::regclass
  AND attnum > 0
  AND NOT attisdropped
ORDER BY attnum;

-- Ukuran tabel utama dan total
SELECT
    pg_size_pretty(pg_relation_size('lab6.event_log')) AS ukuran_heap,
    pg_size_pretty(pg_total_relation_size('lab6.event_log')) AS ukuran_total;

-- Informasi TOAST
SELECT
    c.relname AS nama_tabel,
    c.reltoastrelid::regclass AS toast_table
FROM pg_class c
WHERE c.oid = 'lab6.event_log'::regclass;