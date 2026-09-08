-- Diminta: mencari film dengan tarif di atas rata-rata seluruh film.
-- Dipilih: subquery skalar karena AVG menghasilkan tepat satu nilai.
-- Alternatif: CTE; tidak dipilih karena alur query masih sederhana.
SELECT title, rental_rate,
       (SELECT AVG(rental_rate) FROM film) AS rata_rata,
       rental_rate - (SELECT AVG(rental_rate) FROM film) AS selisih
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC, title;
