-- Diminta: membuat ulang view menggunakan WITH CASCADED CHECK OPTION.
-- Dipilih: CASCADED CHECK OPTION agar INSERT dipaksa memenuhi kondisi view.
-- Alternatif: tanpa CHECK OPTION; tidak dipilih karena memungkinkan baris lolos dari filter view.
DROP VIEW IF EXISTS lab4.film_murah;
CREATE VIEW lab4.film_murah AS
SELECT film_id, title, rental_rate, rating
FROM lab4.film
WHERE rental_rate <= 0.99
WITH CASCADED CHECK OPTION;

INSERT INTO lab4.film_murah (film_id, title, rental_rate, rating)
VALUES (2002, 'FILM UJI Q3', 4.99, 'PG');
