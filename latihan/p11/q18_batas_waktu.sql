-- Q18: batas waktu (statement_timeout)
-- Pemasangan (sekali, sebagai postgres):
--   ALTER ROLE app_portal SET statement_timeout = '5s';
-- File ini dijalankan sebagai app_portal (sesi baru). Batas role tidak berlaku lewat SET ROLE.
-- Uji hanya di basis data lab sendiri.

\set VERBOSITY verbose
SHOW statement_timeout;

-- Di bawah batas: lolos
SELECT pg_sleep(1);

-- Di atas batas: dibatalkan dengan SQLSTATE 57014
SELECT pg_sleep(10);

-- Sesi tetap hidup setelah galat
SELECT 'sesi masih hidup' AS status;