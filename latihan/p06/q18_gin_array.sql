-- 1. Matikan penggunaan index sementara untuk simulasi "Tanpa GIN"
SET enable_indexscan = off;
SET enable_bitmapscan = off;

-- Uji rencana TANPA GIN
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM lab6.event_log WHERE tags @> '{"elektronik"}';  -- ganti teks tag sesuai datamu

-- 2. Kembalikan pengaturan index ke kondisi normal (Dengan GIN)
SET enable_indexscan = on;
SET enable_bitmapscan = on;

-- Uji rencana DENGAN GIN
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM lab6.event_log WHERE tags @> '{"elektronik"}';