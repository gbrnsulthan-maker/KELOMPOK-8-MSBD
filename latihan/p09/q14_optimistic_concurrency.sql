-- Diminta: menguji kolom versi atau kondisi saldo sebagai mekanisme optimistic concurrency.
-- Dipilih: Menambahkan kondisi WHERE pada UPDATE untuk memastikan data belum berubah sejak dibaca.
-- Alternatif: FOR UPDATE; tidak dipilih karena Optimistic Locking tidak memblokir pembaca lain.
-- INSTRUKSI: Simulasi 2 sesi.

-- [SESI 1]
-- BEGIN;
-- UPDATE p09.rekening SET saldo = 900 WHERE id = 1 AND saldo = 1000; -- (Sukses, 1 baris terupdate)
-- COMMIT;

-- [SESI 2] (Membaca saldo = 1000 di awal, mencoba update)
-- UPDATE p09.rekening SET saldo = 800 WHERE id = 1 AND saldo = 1000; 
-- (Hasil: 0 baris terupdate! Aplikasi tahu data sudah berubah dan bisa meminta user refresh).
