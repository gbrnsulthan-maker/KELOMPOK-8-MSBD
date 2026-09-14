-- Diminta: membuktikan baris dapat dimasukkan melalui view tetapi tidak muncul kembali.
-- Dipilih: memasukkan rental_rate 4.99 yang tidak memenuhi kondisi view.
-- Alternatif: memasukkan rental_rate 0.99; tidak dipilih karena baris tetap akan terlihat di view.
INSERT INTO lab4.film_murah (film_id, title, rental_rate, rating)
VALUES (2001, 'FILM UJI Q2', 4.99, 'PG');

SELECT count(*) AS jumlah_di_view FROM lab4.film_murah WHERE title = 'FILM UJI Q2';
SELECT count(*) AS jumlah_di_tabel FROM lab4.film WHERE title = 'FILM UJI Q2';
