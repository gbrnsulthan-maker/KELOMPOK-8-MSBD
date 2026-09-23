ALTER TABLE lab4.film
ADD CONSTRAINT film_pkey PRIMARY KEY (film_id);

-- Membuat tabel ulasan 
CREATE TABLE lab4.ulasan (
    ulasan_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film_id integer,
    isi_ulasan text,
    CONSTRAINT fk_ulasan_film
        FOREIGN KEY (film_id)
        REFERENCES lab4.film(film_id)
        ON DELETE NO ACTION
);

INSERT INTO lab4.ulasan (film_id, isi_ulasan)
VALUES (100000, 'Ulasan untuk pengujian foreign key');

-- Ubah aksi FK menjadi CASCADE
ALTER TABLE lab4.ulasan
DROP CONSTRAINT fk_ulasan_film;

ALTER TABLE lab4.ulasan
ADD CONSTRAINT fk_ulasan_film
    FOREIGN KEY (film_id)
    REFERENCES lab4.film(film_id)
    ON DELETE CASCADE;

-- Uji ON DELETE NO ACTION
DELETE FROM lab4.film
WHERE film_id = 100000;

-- Buat film baru untuk pengujian
INSERT INTO lab4.film (film_id, title, rental_rate)
VALUES (100001, 'Film Uji SET NULL', 1);

-- Buat ulasan untuk film tersebut
INSERT INTO lab4.ulasan (film_id, isi_ulasan)
VALUES (100001, 'Ulasan untuk pengujian SET NULL');

-- Ubah aksi FK menjadi SET NULL
ALTER TABLE lab4.ulasan
DROP CONSTRAINT fk_ulasan_film;

ALTER TABLE lab4.ulasan
ADD CONSTRAINT fk_ulasan_film
    FOREIGN KEY (film_id)
    REFERENCES lab4.film(film_id)
    ON DELETE SET NULL;

DELETE FROM lab4.film
WHERE film_id = 100001;