-- 1. Uji query dengan operator @>
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM lab6.event_log WHERE payload @> '{"promo": true}';

-- 2. Bandingkan ukuran Index GIN dengan tabel utama (Heap)
SELECT 
    pg_size_pretty(pg_relation_size('lab6.event_log')) AS ukuran_heap_tabel,
    pg_size_pretty(pg_relation_size('lab6.ev_payload_gin_idx')) AS ukuran_index_gin;