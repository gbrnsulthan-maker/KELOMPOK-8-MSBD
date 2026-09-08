-- Diminta: menampilkan film dengan tarif tertinggi pada setiap toko tanpa window function.
-- Dipilih: subquery berkorelasi MAX karena sesuai dengan batasan soal.
-- Alternatif: RANK window function; tidak dipakai karena baru akan dibandingkan pada Q11.
SELECT DISTINCT i.store_id, f.film_id, f.title, f.rental_rate
FROM inventory i
JOIN film f ON f.film_id = i.film_id
WHERE f.rental_rate = (
    SELECT MAX(f2.rental_rate)
    FROM inventory i2
    JOIN film f2 ON f2.film_id = i2.film_id
    WHERE i2.store_id = i.store_id
)
ORDER BY i.store_id, f.title;
