-- Q25: jalankan pada database latihan setelah setup lab9.
-- SESI A: biarkan transaksi terbuka setelah SELECT.
BEGIN;
SELECT * FROM lab9.rekening
WHERE rekening_id = 1
FOR UPDATE;

-- SESI B, saat Sesi A masih memegang lock:
-- BEGIN;
-- SELECT * FROM lab9.rekening
-- WHERE rekening_id = 1
-- FOR UPDATE NOWAIT;
-- Hasil yang diharapkan: ERROR could not obtain lock on row.
-- Setelah itu jalankan ROLLBACK di Sesi B dan Sesi A.
