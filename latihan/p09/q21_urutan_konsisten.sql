-- Diminta: Ulangi skenario Q20, tetapi semua sesi mengunci rekening dari id terkecil ke terbesar. Apakah deadlock dapat dihindari?
-- Dipilih: Kedua sesi mengunci id 1 lalu id 2 dengan SELECT ... FOR UPDATE agar tidak terbentuk siklus tunggu.
-- Alternatif: Mengunci kedua baris sekaligus dalam satu query (WHERE id IN (1,2) ORDER BY id FOR UPDATE); tidak dipilih karena soal meminta pengulangan urutan per langkah seperti Q20.
-- INSTRUKSI: Jalankan sesuai urutan nomor. Pastikan tidak ada transaksi tersangkut (ROLLBACK dulu di kedua sesi).

-- [1. SESI A]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;

-- [2. SESI B]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;
-- (Sesi B HANG/ANTRI menunggu kunci id 1. Sesi B belum memegang kunci apa pun.)

-- [3. SESI A]
-- SELECT * FROM p09.rekening WHERE id = 2 FOR UPDATE;
-- (Langsung berhasil, karena id 2 tidak dipegang siapa pun.)
-- COMMIT;

-- [4. SESI B]
-- (Setelah Sesi A COMMIT, kunci id 1 didapat dan baris Andi tampil.)
-- SELECT * FROM p09.rekening WHERE id = 2 FOR UPDATE;
-- COMMIT;