-- Diminta: melakukan backfill data harga lama ke struktur baru.
-- Dipilih: menyalin film_id dan rental_rate dari lab4.film ke lab4.harga_film.
-- Alternatif: menyalin data secara manual per baris, tetapi tidak dipilih karena INSERT SELECT lebih efisien.


INSERT INTO lab4.harga_film (
    film_id,
    rental_rate
)
SELECT
    film_id,
    rental_rate
FROM lab4.film
ON CONFLICT (film_id)
DO UPDATE SET
    rental_rate = EXCLUDED.rental_rate;