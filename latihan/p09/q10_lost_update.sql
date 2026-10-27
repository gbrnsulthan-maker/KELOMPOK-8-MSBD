-- Diminta: mereproduksi lost update menggunakan dua sesi.
-- Dipilih: Simulasi klasik dua transaksi membaca nilai yang sama lalu mengoverwrite.
-- Alternatif: Menggunakan FOR UPDATE; tidak dipilih karena ini adalah eksperimen untuk membuktikan MASALAH lost update.
-- INSTRUKSI: Jalankan berurutan di 2 Terminal berbeda.

-- [SESI 1]
-- BEGIN;
-- SELECT saldo FROM p09.rekening WHERE id = 1; -- (Misal: 1000)

-- [SESI 2]
-- BEGIN;
-- SELECT saldo FROM p09.rekening WHERE id = 1; -- (Baca: 1000 juga)

-- [SESI 1]
-- UPDATE p09.rekening SET saldo = 900 WHERE id = 1;
-- COMMIT;

-- [SESI 2]
-- UPDATE p09.rekening SET saldo = 800 WHERE id = 1; -- (Menimpa update Sesi 1!)
-- COMMIT;

-- [SESI 1]
-- SELECT saldo FROM p09.rekening WHERE id = 1; -- Hasil: 800 (Update Sesi 1 hilang/lost)
