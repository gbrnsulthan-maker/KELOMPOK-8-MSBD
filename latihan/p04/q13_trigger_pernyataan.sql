CREATE OR REPLACE FUNCTION lab4.catat_audit_massal()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO lab4.audit_harga (
        film_id,
        harga_lama,
        harga_baru,
        diubah_oleh,
        diubah_pada
    )
    SELECT
        lama.film_id,
        lama.rental_rate,
        baru.rental_rate,
        CURRENT_USER,
        CURRENT_TIMESTAMP
    FROM lama
    JOIN baru
      ON lama.film_id = baru.film_id
    WHERE lama.rental_rate IS DISTINCT FROM baru.rental_rate;

    RETURN NULL;
END;
$$;

-- trigger
CREATE TRIGGER film_audit_harga_massal
AFTER UPDATE ON lab4.film
REFERENCING OLD TABLE AS lama NEW TABLE AS baru
FOR EACH STATEMENT
EXECUTE FUNCTION lab4.catat_audit_massal();