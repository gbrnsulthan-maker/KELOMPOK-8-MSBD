-- 1. Buat B-Tree Index untuk perbandingan (BRIN sudah dibuat di Langkah 5)
CREATE INDEX IF NOT EXISTS ev_btree_idx ON lab6.event_log (terjadi_pada);

-- 2. Cek korelasi kolom terjadi_pada pada pg_stats
SELECT tablename, attname, correlation 
FROM pg_stats 
WHERE tablename = 'event_log' AND attname = 'terjadi_pada';

-- 3. Bandingkan Ukuran Index BRIN vs B-Tree
SELECT 
    pg_size_pretty(pg_relation_size('lab6.ev_terjadi_pada_brin_idx')) AS ukuran_brin,
    pg_size_pretty(pg_relation_size('lab6.ev_btree_idx')) AS ukuran_btree,
    pg_size_pretty(pg_relation_size('lab6.event_log')) AS ukuran_tabel_heap;