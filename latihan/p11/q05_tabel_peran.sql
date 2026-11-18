-- ============================================
-- Q5: TABEL TUJUH PERAN
-- ============================================

-- Membuat tabel dokumentasi tujuh peran
CREATE TABLE IF NOT EXISTS p11.tabel_peran (
    id SERIAL PRIMARY KEY,
    nama_peran VARCHAR(50) NOT NULL,
    tanggung_jawab TEXT NOT NULL,
    hak_akses TEXT NOT NULL
);

-- Memasukkan tujuh peran
INSERT INTO p11.tabel_peran
    (nama_peran, tanggung_jawab, hak_akses)
VALUES
    (
        'Administrator',
        'Mengelola seluruh database dan pengguna',
        'Mengelola role, schema, tabel, dan seluruh hak akses'
    ),
    (
        'Pemilik Tabel',
        'Mengelola tabel yang dimilikinya',
        'SELECT, INSERT, UPDATE, DELETE, ALTER, DROP'
    ),
    (
        'Pengelola Data',
        'Mengelola isi tabel',
        'SELECT, INSERT, UPDATE, DELETE'
    ),
    (
        'Analis',
        'Membaca dan menganalisis data',
        'SELECT'
    ),
    (
        'Penguji',
        'Melakukan pengujian hak akses',
        'SELECT, INSERT, UPDATE, DELETE sesuai GRANT'
    ),
    (
        'Penerima Akses',
        'Menerima hak akses dari role lain',
        'Sesuai hak yang diberikan'
    ),
    (
        'Pengguna Biasa',
        'Mengakses data sesuai kebutuhan',
        'Akses terbatas sesuai GRANT'
    );

-- Menampilkan tabel tujuh peran
SELECT *
FROM p11.tabel_peran
ORDER BY id;