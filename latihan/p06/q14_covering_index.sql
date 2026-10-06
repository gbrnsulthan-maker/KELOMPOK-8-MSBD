-- 1. Buat Covering Index dengan INCLUDE
CREATE INDEX IF NOT EXISTS ev_cover_idx 
ON lab6.event_log (customer_id) INCLUDE (terjadi_pada, jumlah);

-- 2. Uji Query Cakupan SEBELUM VACUUM
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_id, terjadi_pada, jumlah 
FROM lab6.event_log 
WHERE customer_id = 10;

-- 3. Jalankan VACUUM ANALYZE
VACUUM (ANALYZE) lab6.event_log;

-- 4. Uji Query Cakupan SESUDAH VACUUM
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_id, terjadi_pada, jumlah 
FROM lab6.event_log 
WHERE customer_id = 10;