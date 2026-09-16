-- Diminta: Melakukan tahap expand dengan membuat struktur harga baru
--          dan memasang dual-write agar perubahan rental_rate pada
--          struktur lama ikut tercatat pada struktur baru.
-- Dipilih: Membuat tabel lab4.harga_film dan trigger AFTER INSERT
--          OR UPDATE OF rental_rate pada lab4.film.
--          Cara ini menjaga aplikasi lama tetap dapat menggunakan
--          rental_rate selama proses migrasi berlangsung.
-- Alternatif: Memindahkan rental_rate langsung ke harga_film tidak dipakai
--             karena dapat memutus kompatibilitas dengan aplikasi lama.

-- =========================================================
-- Q18 - EXPAND: STRUKTUR BARU
-- =========================================================

CREATE TABLE lab4.harga_film (
    film_id integer NOT NULL,
    wilayah varchar(10) NOT NULL,
    harga numeric(4,2) NOT NULL,
    berlaku daterange NOT NULL,
    PRIMARY KEY (film_id, wilayah),
    FOREIGN KEY (film_id) REFERENCES lab4.film(film_id)
);

-- =========================================================
-- Q18 - DUAL-WRITE
-- =========================================================

CREATE OR REPLACE FUNCTION lab4.sync_harga_film()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab4.harga_film (
        film_id,
        wilayah,
        harga,
        berlaku
    )
    VALUES (
        NEW.film_id,
        'ID',
        NEW.rental_rate,
        daterange('2026-01-01', NULL)
    )
    ON CONFLICT (film_id, wilayah)
    DO UPDATE SET
        harga = EXCLUDED.harga,
        berlaku = EXCLUDED.berlaku;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sync_harga_film
AFTER INSERT OR UPDATE OF rental_rate
ON lab4.film
FOR EACH ROW
EXECUTE FUNCTION lab4.sync_harga_film();

-- =========================================================
-- VERIFIKASI DUAL-WRITE
-- =========================================================

UPDATE lab4.film
SET rental_rate = 1.99
WHERE film_id = 1;

SELECT film_id, wilayah, harga, berlaku
FROM lab4.harga_film
WHERE film_id = 1;