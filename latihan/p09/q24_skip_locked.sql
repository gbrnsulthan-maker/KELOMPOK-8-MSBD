-- Diminta: Buat tabel antrean pekerjaan (id, status). Sesi A mengunci satu baris. Sesi B menjalankan
--          SELECT ... FOR UPDATE SKIP LOCKED. Baris mana yang dikembalikan? Jelaskan kegunaannya untuk worker antrean.
-- Dipilih: SKIP LOCKED agar worker tidak antre pada baris yang sedang diproses worker lain.
-- Alternatif: FOR UPDATE biasa (worker menunggu baris yang sama, antrean macet) atau NOWAIT (langsung error);
--             tidak dipilih karena worker seharusnya langsung mengambil pekerjaan lain yang masih bebas.
-- INSTRUKSI: Jalankan setup, lalu Sesi A (jangan COMMIT), lalu Sesi B.

-- [SETUP] (satu sesi saja)
DROP TABLE IF EXISTS p09.antrean_pekerjaan;
CREATE TABLE p09.antrean_pekerjaan (
    id     SERIAL PRIMARY KEY,
    status TEXT NOT NULL DEFAULT 'menunggu'
);
INSERT INTO p09.antrean_pekerjaan (status)
SELECT 'menunggu' FROM generate_series(1, 5);
SELECT * FROM p09.antrean_pekerjaan ORDER BY id;

-- [SESI A]
-- BEGIN;
-- SELECT * FROM p09.antrean_pekerjaan WHERE status = 'menunggu' ORDER BY id LIMIT 1 FOR UPDATE;
-- (Baris id = 1 terkunci. Jangan COMMIT.)

-- [SESI B]
-- BEGIN;
-- SELECT * FROM p09.antrean_pekerjaan WHERE status = 'menunggu' ORDER BY id LIMIT 1 FOR UPDATE SKIP LOCKED;
-- (Tidak menggantung. Mengembalikan baris id = 2, karena id = 1 dilewati.)

-- [BERSIHKAN]
-- ROLLBACK;  -- di Sesi A dan Sesi B