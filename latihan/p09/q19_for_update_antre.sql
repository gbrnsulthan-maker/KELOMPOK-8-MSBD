-- Diminta: Sesi A kunci rekening 1 dengan FOR UPDATE, Sesi B coba kunci baris yang sama, catat perilaku menunggu dan hasil setelah Sesi A COMMIT.
-- Dipilih: FOR UPDATE di kedua sesi agar antrean kunci terlihat jelas.
-- Alternatif: NOWAIT / SKIP LOCKED; tidak dipilih karena soal meminta mengamati perilaku menunggu.

-- [SESI A]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;
-- (Baris id = 1 terkunci eksklusif. Jangan COMMIT dulu.)

-- [SESI B]
-- BEGIN;
-- SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;
-- (Sesi B HANG/ANTRI, tidak ada hasil yang keluar selama Sesi A belum selesai.)

-- [SESI C - opsional, sebagai bukti Sesi B sedang menunggu]
-- SELECT pid, state, wait_event_type, wait_event, left(query, 50) AS query
-- FROM pg_stat_activity
-- WHERE datname = current_database() AND wait_event_type = 'Lock';
-- (Harapan: wait_event_type = Lock, wait_event = transactionid)

-- [SESI A]
-- COMMIT;
-- (Kunci dilepas.)

-- [SESI B]
-- (Begitu Sesi A COMMIT, SELECT Sesi B langsung selesai dan menampilkan baris id = 1.)
-- COMMIT;

-- HASIL: Sesi B menunggu selama Sesi A belum COMMIT, lalu langsung berjalan setelah Sesi A COMMIT.