-- Diminta: memperbaiki lost update dengan pembaruan atomik.
-- Dipilih: Melakukan UPDATE langsung tanpa SELECT sebelumnya, membiarkan PostgreSQL menangani konkurensi.
-- Alternatif: Menggunakan aplikasi untuk mengunci; tidak dipilih karena kurang efisien.
-- INSTRUKSI: Jalankan di 2 sesi secara bersamaan.

-- [SESI 1]
-- UPDATE p09.rekening SET saldo = saldo - 100 WHERE id = 1;

-- [SESI 2] (Jalankan tepat setelah Sesi 1, sebelum Sesi 1 COMMIT)
-- UPDATE p09.rekening SET saldo = saldo - 200 WHERE id = 1; 
-- (Sesi 2 akan MENUNGGU Sesi 1 COMMIT/ROLLBACK, lalu menghitung dari nilai terbaru. Tidak ada Lost Update!)
