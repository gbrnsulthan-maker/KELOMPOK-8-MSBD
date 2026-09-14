-- Diminta: membuat audit perubahan rental_rate pada tabel film.
-- Dipilih: menggunakan AFTER UPDATE OF rental_rate dengan WHEN IS DISTINCT FROM.
-- Alternatif: menggunakan trigger BEFORE atau memeriksa perubahan di dalam function, tetapi tidak dipilih.


CREATE TABLE IF NOT EXISTS lab4.audit_harga (
    audit_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film_id integer NOT NULL,
    harga_lama numeric,
    harga_baru numeric,
    diubah_oleh text NOT NULL,
    diubah_pada timestamptz NOT NULL
);


CREATE OR REPLACE FUNCTION lab4.fn_audit_harga()
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
    VALUES (
        OLD.film_id,
        OLD.rental_rate,
        NEW.rental_rate,
        CURRENT_USER,
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$;


CREATE TRIGGER film_audit_harga
AFTER UPDATE OF rental_rate ON lab4.film
FOR EACH ROW
WHEN (OLD.rental_rate IS DISTINCT FROM NEW.rental_rate)
EXECUTE FUNCTION lab4.fn_audit_harga();