-- Diminta: membuat view film murah dengan rental_rate <= 0.99.
-- Dipilih: simple view tanpa CHECK OPTION agar perilaku INSERT dapat diuji pada Q2.
-- Alternatif: WITH CHECK OPTION; belum digunakan karena baru diminta pada Q3.
DROP VIEW IF EXISTS lab4.film_murah;
CREATE VIEW lab4.film_murah AS
SELECT film_id, title, rental_rate, rating
FROM lab4.film
WHERE rental_rate <= 0.99;

SELECT * FROM lab4.film_murah LIMIT 5;
