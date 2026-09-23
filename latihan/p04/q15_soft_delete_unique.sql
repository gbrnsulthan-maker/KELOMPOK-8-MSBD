--Soft-delete dan unique index parsial

ALTER TABLE lab4.film
ADD COLUMN deleted_at timestamptz;

ALTER TABLE lab4.film
ADD CONSTRAINT film_judul_unik UNIQUE (title);

--uji soft-delete
UPDATE lab4.film
SET deleted_at = CURRENT_TIMESTAMP
WHERE film_id = 99999;

--daftarkan kembali film yang sudah dihapus
INSERT INTO lab4.film (film_id, title, rental_rate)
VALUES (100000, 'Film Uji Negatif', 1);

-- Bukti: pendaftaran ulang judul gagal karena UNIQUE biasa
-- ERROR: duplicate key value violates unique constraint "film_judul_unik"
-- Judul tetap dianggap sudah ada walaupun deleted_at tidak NULL.

ALTER TABLE lab4.film
DROP CONSTRAINT film_judul_unik;

-- Buat unique untuk judul film yang belum dihapus
CREATE UNIQUE INDEX ux_film_judul_aktif
ON lab4.film (title)
WHERE deleted_at IS NULL;

--pendaftaran ulang judul dari soft-delete
INSERT INTO lab4.film (film_id, title, rental_rate)
VALUES (100000, 'Film Uji Negatif', 1);