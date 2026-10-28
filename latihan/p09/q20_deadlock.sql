-- Diminta: Sesi A kunci rekening 1, Sesi B kunci rekening 2. Lalu Sesi A coba kunci rekening 2 dan Sesi B coba kunci rekening 1.
--          Rekam sesi mana yang mendapat deadlock error dan SQLSTATE 40P01.
-- Dipilih: SELECT ... FOR UPDATE dengan urutan kunci yang saling bersilangan agar deadlock terjadi dan terdeteksi PostgreSQL.
-- Alternatif: UPDATE langsung pada dua baris dengan urutan terbalik; tidak dipilih karena soal meminta pakai SELECT ... FOR UPDATE.
-- INSTRUKSI: Jalankan sesuai urutan nomor. Jangan COMMIT/ROLLBACK sebelum deadlock terjadi.
--            Jalankan \set VERBOSITY verbose di kedua sesi agar SQLSTATE tampil.

-- [SESI A & B] (persiapan)
-- \set VERBOSITY verbose

-- [1. SESI A]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;

-- [2. SESI B]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 2 FOR UPDATE;

-- [3. SESI A]
-- SELECT * FROM p09.rekening WHERE id = 2 FOR UPDATE;
-- (Sesi A HANG/ANTRI menunggu kunci rekening 2 milik Sesi B.)

-- [4. SESI B]
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;
-- (Sesi B menunggu kunci rekening 1 milik Sesi A -> saling menunggu -> DEADLOCK.)
-- (Setelah ~1 detik, salah satu sesi dibatalkan dengan ERROR: deadlock detected.)

-- [5. SESI A & B]
-- ROLLBACK;