-- Diminta: Melakukan tahap contract dengan menyediakan facade
--          yang mempertahankan bentuk lama agar aplikasi lama
--          tetap dapat membaca kolom rental_rate.
-- Dipilih: Menggunakan view lab4.film sebagai facade, sedangkan
--          tabel fisik lama diubah menjadi lab4.film_base.
--          Nilai rental_rate pada facade diambil dari lab4.harga_film.
-- Alternatif: Menggunakan view dengan nama lab4.film_fasad tidak
--             dipakai sebagai bentuk akhir karena aplikasi lama
--             tetap mengakses lab4.film.

-- Hentikan dual-write sebelum bentuk lama dihapus.
DROP TRIGGER trg_sync_harga_film ON lab4.film;
DROP FUNCTION lab4.sync_harga_film();

-- Menghapus kolom harga lama.
ALTER TABLE lab4.film
DROP COLUMN rental_rate;

-- Mengubah nama tabel fisik agar nama lab4.film
-- dapat digunakan sebagai facade untuk aplikasi lama.
ALTER TABLE lab4.film
RENAME TO film_base;

-- Membuat facade dengan nama yang tetap dikenal aplikasi lama.
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

-- Verifikasi facade.
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;