-- Q28: Jalankan di sesi psql pada database latihan.
BEGIN ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM lab9.dokter_jaga
WHERE aktif = TRUE;

SELECT locktype, mode, granted,
       relation::regclass AS relation_name, page, tuple
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND mode = 'SIReadLock';

-- SIReadLock digunakan untuk mendeteksi konflik serialisasi.
-- Hasil dapat berbeda sesuai query dan rencana eksekusi.
ROLLBACK;
