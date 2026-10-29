-- Q26: Write skew pada REPEATABLE READ.
-- Jalankan bagian setup satu kali.
CREATE TABLE IF NOT EXISTS lab9.dokter_jaga (
    dokter_id INT PRIMARY KEY,
    nama TEXT NOT NULL,
    aktif BOOLEAN NOT NULL
);

INSERT INTO lab9.dokter_jaga (dokter_id, nama, aktif)
VALUES (1, 'Dokter A', TRUE), (2, 'Dokter B', TRUE)
ON CONFLICT (dokter_id) DO UPDATE
SET nama = EXCLUDED.nama, aktif = EXCLUDED.aktif;

-- SESI A: jalankan BEGIN dan SELECT, lalu UPDATE; jangan commit dulu.
-- BEGIN ISOLATION LEVEL REPEATABLE READ;
-- SELECT COUNT(*) FROM lab9.dokter_jaga WHERE aktif;
-- UPDATE lab9.dokter_jaga SET aktif = FALSE WHERE dokter_id = 1;
--
-- SESI B: mulai sebelum Sesi A commit.
-- BEGIN ISOLATION LEVEL REPEATABLE READ;
-- SELECT COUNT(*) FROM lab9.dokter_jaga WHERE aktif;
-- UPDATE lab9.dokter_jaga SET aktif = FALSE WHERE dokter_id = 2;
--
-- Coba commit kedua sesi, lalu periksa:
-- SELECT COUNT(*) FROM lab9.dokter_jaga WHERE aktif;
-- Jika hasil nol, aturan "minimal satu dokter aktif" telah dilanggar.
-- Catat output aktual; hasil ini belum diverifikasi.
