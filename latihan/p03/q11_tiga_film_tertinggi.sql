-- Diminta: menampilkan tiga film dengan tarif tertinggi di setiap kategori.
-- Dipilih: window dihitung di CTE lalu disaring di lapisan luar karena hasil window tidak boleh difilter di WHERE level yang sama.
-- Alternatif: subquery berkorelasi seperti Q5; tidak dipakai karena soal meminta perbandingan bentuk window function.
WITH peringkat AS (
    SELECT
        f.title,
        c.name AS kategori,
        f.rental_rate,
        DENSE_RANK() OVER (
            PARTITION BY c.category_id
            ORDER BY f.rental_rate DESC
        ) AS peringkat
    FROM film f
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category c ON c.category_id = fc.category_id
)
SELECT *
FROM peringkat
WHERE peringkat <= 3
ORDER BY kategori, peringkat, title;
