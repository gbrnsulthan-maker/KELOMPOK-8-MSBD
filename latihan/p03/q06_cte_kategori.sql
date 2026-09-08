-- Diminta: menghitung jumlah film dan rata-rata tarif setiap kategori menggunakan CTE bertingkat.
-- Dipilih: dua CTE berurutan agar perhitungan dipisahkan secara logis.
-- Alternatif: satu query GROUP BY; tidak dipakai karena soal meminta CTE bertingkat.

WITH jumlah_film AS (
    SELECT
        c.category_id,
        c.name AS kategori,
        COUNT(fc.film_id) AS jumlah_film
    FROM category c
    JOIN film_category fc
        ON c.category_id = fc.category_id
    GROUP BY c.category_id, c.name
),
rata_tarif AS (
    SELECT
        c.category_id,
        AVG(f.rental_rate) AS rata_rata_tarif
    FROM category c
    JOIN film_category fc
        ON c.category_id = fc.category_id
    JOIN film f
        ON fc.film_id = f.film_id
    GROUP BY c.category_id
)
SELECT
    j.kategori,
    j.jumlah_film,
    r.rata_rata_tarif
FROM jumlah_film j
JOIN rata_tarif r
    ON j.category_id = r.category_id
WHERE j.jumlah_film > 60
ORDER BY j.jumlah_film DESC;