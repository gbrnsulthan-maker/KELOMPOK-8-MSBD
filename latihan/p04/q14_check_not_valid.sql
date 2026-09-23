-- Check constraint for valid rental rates

INSERT INTO lab4.film (film_id, title, rental_rate)
VALUES (99999, 'Film Uji Negatif', -1);

ALTER TABLE lab4.film
ADD CONSTRAINT film_rental_rate_nonneg
CHECK (rental_rate >= 0) NOT VALID;

ALTER TABLE lab4.film
VALIDATE CONSTRAINT film_rental_rate_nonneg;

UPDATE lab4.film
SET rental_rate = 0
WHERE film_id = 99999;

ALTER TABLE lab4.film
VALIDATE CONSTRAINT film_rental_rate_nonneg;