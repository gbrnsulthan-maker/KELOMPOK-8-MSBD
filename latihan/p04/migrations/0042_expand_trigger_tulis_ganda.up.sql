-- Diminta: membuat tahap dual-write pada proses expand-contract.
-- Dipilih: menggunakan trigger untuk menyalin perubahan rental_rate dari lab4.film ke lab4.harga_film.
-- Alternatif: melakukan backfill sekaligus, tetapi tidak dipilih karena backfill dilakukan pada migration 0043.


CREATE OR REPLACE FUNCTION lab4.fn_dual_write_harga_film()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab4.harga_film (
        film_id,
        rental_rate
    )
    VALUES (
        NEW.film_id,
        NEW.rental_rate
    )
    ON CONFLICT (film_id)
    DO UPDATE SET
        rental_rate = EXCLUDED.rental_rate;

    RETURN NEW;
END;
$$;


CREATE TRIGGER film_dual_write_harga
AFTER INSERT OR UPDATE OF rental_rate ON lab4.film
FOR EACH ROW
EXECUTE FUNCTION lab4.fn_dual_write_harga_film();