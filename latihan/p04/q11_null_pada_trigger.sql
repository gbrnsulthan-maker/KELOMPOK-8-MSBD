-- Diminta: menguji perilaku trigger ketika nilai rental_rate melibatkan NULL.
-- Dipilih: mengganti IS DISTINCT FROM dengan <> lalu menguji ordinary → NULL dan NULL → ordinary.
-- Alternatif: tetap menggunakan IS DISTINCT FROM, tetapi tidak menunjukkan masalah perbandingan NULL dengan <>.


-- Ganti kondisi trigger dari IS DISTINCT FROM menjadi <>
DROP TRIGGER IF EXISTS film_audit_harga ON lab4.film;

CREATE TRIGGER film_audit_harga
AFTER UPDATE OF rental_rate ON lab4.film
FOR EACH ROW
WHEN (OLD.rental_rate <> NEW.rental_rate)
EXECUTE FUNCTION lab4.fn_audit_harga();


-- Uji ordinary → NULL
UPDATE lab4.film
SET rental_rate = NULL
WHERE film_id = 1;


-- Uji NULL → ordinary
UPDATE lab4.film
SET rental_rate = 4.99
WHERE film_id = 1;


-- Periksa hasil audit
SELECT *
FROM lab4.audit_harga
WHERE film_id = 1
ORDER BY audit_id DESC;