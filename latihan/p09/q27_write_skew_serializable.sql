-- Q27: Ulangi write skew pada SERIALIZABLE.
-- Reset sebelum memulai:
UPDATE lab9.dokter_jaga SET aktif = TRUE;

-- SESI A:
-- BEGIN ISOLATION LEVEL SERIALIZABLE;
-- SELECT COUNT(*) FROM lab9.dokter_jaga WHERE aktif;
-- UPDATE lab9.dokter_jaga SET aktif = FALSE WHERE dokter_id = 1;
--
-- SESI B, sebelum Sesi A commit:
-- BEGIN ISOLATION LEVEL SERIALIZABLE;
-- SELECT COUNT(*) FROM lab9.dokter_jaga WHERE aktif;
-- UPDATE lab9.dokter_jaga SET aktif = FALSE WHERE dokter_id = 2;
--
-- Coba commit kedua sesi. Salah satu dapat gagal dengan SQLSTATE 40001.
-- Setelah kegagalan, ROLLBACK sesi yang gagal dan catat hasil aktual.
