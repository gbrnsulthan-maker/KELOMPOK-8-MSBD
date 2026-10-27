-- Diminta: menguji READ UNCOMMITTED dan membuktikan perilaku dirty read di PostgreSQL.
-- Dipilih: Membuka 2 sesi untuk mensimulasikan transaksi berjalan dan pembacaan dari sesi lain.
-- Alternatif: Membaca teori saja; tidak dipilih karena modul meminta bukti empiris.
-- INSTRUKSI: Jalankan Sesi 1 dulu, JANGAN di-COMMIT. Lalu buka Sesi 2 dan jalankan query di sana.

-- [SESI 1]
-- BEGIN;
-- UPDATE p09.rekening SET saldo = saldo - 100 WHERE id = 1;
-- (JANGAN DI-COMMIT DULU!)

-- [SESI 2]
-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- SELECT saldo FROM p09.rekening WHERE id = 1;
-- 
-- HASIL YANG DIHARAPKAN: Sesi 2 tetap melihat saldo LAMA. 
-- PostgreSQL mencegah Dirty Read dengan memperlakukan READ UNCOMMITTED sebagai READ COMMITTED.
