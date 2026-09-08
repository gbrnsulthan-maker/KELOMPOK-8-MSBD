-- Diminta: menampilkan kategori yang memiliki lebih dari 60 film.
-- Dipilih: derived table agar agregasi selesai dulu lalu difilter dari luar.
-- Alternatif: HAVING; lebih pendek, tetapi derived table dipakai untuk menunjukkan konsep subquery di FROM.
SELECT x.nama_kategori, x.jumlah_film
FROM (
    SELECT c.name AS nama_kategori, COUNT(*) AS jumlah_film
    FROM category c
    JOIN film_category fc ON fc.category_id = c.category_id
    GROUP BY c.category_id, c.name
) AS x
WHERE x.jumlah_film > 60
ORDER BY x.jumlah_film DESC;
