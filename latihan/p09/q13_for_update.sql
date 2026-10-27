-- Diminta: menguji SELECT ... FOR UPDATE (Pessimistic Locking).
-- Dipilih: Mengunci baris secara eksplisit agar transaksi lain harus mengantri.
-- Alternatif: Atomic update; tidak dipilih karena kadang aplikasi butuh membaca dulu sebelum memutuskan.
-- INSTRUKSI: Jalankan Sesi 1, JANGAN COMMIT. Lalu jalankan Sesi 2.

-- [SESI 1]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;

-- [SESI 2]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;
-- (Sesi 2 akan HANG/ANTRI sampai Sesi 1 melakukan COMMIT atau ROLLBACK).
