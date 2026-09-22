-- P05 Q00
-- Menyiapkan schema dan tabel transaksi untuk latihan transaction control.

CREATE SCHEMA IF NOT EXISTS lab5;

DROP TABLE IF EXISTS lab5.payment_tx;
DROP TABLE IF EXISTS lab5.rental_tx;

CREATE TABLE lab5.rental_tx (
    rental_id bigint PRIMARY KEY,
    customer_id integer NOT NULL,
    inventory_id integer NOT NULL,
    rental_date timestamptz NOT NULL DEFAULT now(),
    status text NOT NULL
);

CREATE TABLE lab5.payment_tx (
    payment_id bigserial PRIMARY KEY,
    rental_id bigint NOT NULL,
    customer_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT payment_tx_rental_fk
        FOREIGN KEY (rental_id)
        REFERENCES lab5.rental_tx(rental_id),

    CONSTRAINT payment_tx_positive_amount
        CHECK (amount > 0)
);