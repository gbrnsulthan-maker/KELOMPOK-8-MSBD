-- Q17: EXCLUDE untuk mencegah periode harga tumpang tindih

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE lab4.harga_film (
    harga_film_id bigserial PRIMARY KEY,
    film_id integer NOT NULL REFERENCES lab4.film (film_id),
    wilayah text NOT NULL,
    harga numeric(5,2) NOT NULL CHECK (harga >= 0),
    berlaku daterange NOT NULL,
    EXCLUDE USING gist (
        film_id WITH =,
        wilayah WITH =,
        berlaku WITH &&
    )
);

-- INSERT pertama: belum bertabrakan
INSERT INTO lab4.harga_film
    (film_id, wilayah, harga, berlaku)
VALUES
    (1, 'ID', 10.00, '[2026-01-01,2026-02-01)');

-- INSERT kedua: tumpang tindih
INSERT INTO lab4.harga_film
    (film_id, wilayah, harga, berlaku)
VALUES
    (1, 'ID', 12.00, '[2026-01-15,2026-02-15)');