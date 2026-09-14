-- Diminta: menguji trigger audit pada perubahan rental_rate.
-- Dipilih: melakukan tiga jenis UPDATE untuk membuktikan kondisi trigger.
-- Alternatif: menguji satu UPDATE saja, tetapi tidak cukup untuk membuktikan semua kondisi.


-- 1. rental_rate berubah
-- Seharusnya menghasilkan satu baris audit.

UPDATE lab4.film
SET rental_rate = rental_rate + 0.01
WHERE film_id = 1;

SELECT *
FROM lab4.audit_harga
WHERE film_id = 1
ORDER BY audit_id DESC
LIMIT 1;


-- 2. rental_rate diubah ke nilai yang sama
-- Seharusnya tidak menghasilkan audit baru.

UPDATE lab4.film
SET rental_rate = rental_rate
WHERE film_id = 1;

SELECT *
FROM lab4.audit_harga
WHERE film_id = 1
ORDER BY audit_id DESC
LIMIT 1;


-- 3. Hanya title yang berubah
-- Seharusnya tidak menghasilkan audit baru.

UPDATE lab4.film
SET title = title
WHERE film_id = 1;

SELECT *
FROM lab4.audit_harga
WHERE film_id = 1
ORDER BY audit_id DESC
LIMIT 1;