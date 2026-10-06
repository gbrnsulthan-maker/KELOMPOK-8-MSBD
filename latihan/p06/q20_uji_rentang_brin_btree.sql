-- 1. Uji Penggunaan B-Tree Index
SET enable_bitmapscan = off;  -- paksa menggunakan B-Tree biasa
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM lab6.event_log 
WHERE terjadi_pada BETWEEN '2024-01-01' AND '2024-01-08';

-- 2. Uji Penggunaan BRIN Index
SET enable_bitmapscan = on;
SET enable_indexscan = off;  -- paksa menggunakan BRIN (Bitmap Index Scan)
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM lab6.event_log 
WHERE terjadi_pada BETWEEN '2024-01-01' AND '2024-01-08';

-- 3. Kembalikan settingan ke default
RESET enable_indexscan;
RESET enable_bitmapscan;