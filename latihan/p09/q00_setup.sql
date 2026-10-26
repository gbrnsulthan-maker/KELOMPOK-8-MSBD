
CREATE SCHEMA IF NOT EXISTS p09;

DROP TABLE IF EXISTS p09.rekening;

CREATE TABLE p09.rekening (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    saldo NUMERIC(12,2) NOT NULL CHECK (saldo >= 0)
);

INSERT INTO p09.rekening (id, nama, saldo) VALUES
(1, 'Andi', 1000000),
(2, 'Budi', 1500000),
(3, 'Citra', 2000000);
