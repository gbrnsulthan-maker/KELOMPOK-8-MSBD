-- 1. Buat Index 3 Kolom biasa (Composite Index)
CREATE INDEX IF NOT EXISTS ev_comp_3col_idx 
ON lab6.event_log (customer_id, terjadi_pada, jumlah);

-- 2. Bandingkan Ukuran Index
SELECT 
    pg_size_pretty(pg_relation_size('lab6.ev_cover_idx')) AS ukuran_index_include,
    pg_size_pretty(pg_relation_size('lab6.ev_comp_3col_idx')) AS ukuran_index_composite;

-- 3. Uji Rencana Eksekusi, Heap Fetches, dan Execution Time
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_id, terjadi_pada, jumlah 
FROM lab6.event_log 
WHERE customer_id = 10;