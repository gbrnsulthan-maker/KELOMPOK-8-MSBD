-- 0045_contract_view_fasad.up.sql
-- Tahap contract: menyiapkan facade dengan bentuk yang tetap
-- menyediakan rental_rate untuk aplikasi lama.

-- Tabel fisik lama dipindahkan ke nama film_base
-- agar nama lab4.film dapat digunakan sebagai facade.
ALTER TABLE lab4.film
RENAME TO film_base;

-- Facade mempertahankan bentuk lama lab4.film.
-- rental_rate tidak lagi menjadi sumber utama dari tabel film,
-- tetapi dibaca dari struktur harga_film.
CREATE VIEW lab4.film AS
SELECT
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    f.language_id,
    f.original_language_id,
    f.rental_duration,
    h.harga AS rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.last_update,
    f.special_features,
    f.fulltext
FROM lab4.film_base f
LEFT JOIN lab4.harga_film h
    ON h.film_id = f.film_id
   AND h.wilayah = 'ID';

-- Verifikasi bahwa old reader masih dapat memakai bentuk lama.
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;