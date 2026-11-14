-- ============================================
-- MSBD PERTEMUAN 11
-- Q00: SETUP AWAL
-- ============================================

-- Membuat schema P11
CREATE SCHEMA IF NOT EXISTS p11;

-- Membersihkan tabel jika setup dijalankan ulang
DROP TABLE IF EXISTS p11.data_pengujian CASCADE;

-- Membuat tabel untuk pengujian hak akses
CREATE TABLE p11.data_pengujian (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    keterangan TEXT
);

-- Memasukkan data awal
INSERT INTO p11.data_pengujian (nama, keterangan) VALUES
('Data 1', 'Data awal untuk pengujian hak akses'),
('Data 2', 'Data untuk pengujian GRANT dan REVOKE'),
('Data 3', 'Data untuk pengujian kepemilikan tabel');

-- Memeriksa jumlah data
SELECT COUNT(*) AS jumlah_data
FROM p11.data_pengujian;

-- Menampilkan seluruh data
SELECT *
FROM p11.data_pengujian;