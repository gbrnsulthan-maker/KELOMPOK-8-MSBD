-- Q5 - Fillfactor dan HOT Update

DROP TABLE IF EXISTS lab6.hot_penuh;
DROP TABLE IF EXISTS lab6.hot_longgar;

CREATE TABLE lab6.hot_penuh (
    id serial PRIMARY KEY,
    nama text,
    keterangan text
) WITH (fillfactor = 100);

CREATE TABLE lab6.hot_longgar (
    id serial PRIMARY KEY,
    nama text,
    keterangan text
) WITH (fillfactor = 80);

INSERT INTO lab6.hot_penuh (nama, keterangan)
SELECT
    'Nama ' || gs,
    'Keterangan awal ' || gs
FROM generate_series(1, 100000) AS gs;

INSERT INTO lab6.hot_longgar (nama, keterangan)
SELECT
    'Nama ' || gs,
    'Keterangan awal ' || gs
FROM generate_series(1, 100000) AS gs;

ANALYZE lab6.hot_penuh;
ANALYZE lab6.hot_longgar;

-- Update kolom yang tidak memiliki index
UPDATE lab6.hot_penuh
SET keterangan = keterangan || ' updated';

UPDATE lab6.hot_longgar
SET keterangan = keterangan || ' updated';

SELECT pg_stat_clear_snapshot();

SELECT
    'hot_penuh' AS tabel,
    n_tup_upd,
    n_tup_hot_upd
FROM pg_stat_all_tables
WHERE relid = 'lab6.hot_penuh'::regclass

UNION ALL

SELECT
    'hot_longgar' AS tabel,
    n_tup_upd,
    n_tup_hot_upd
FROM pg_stat_all_tables
WHERE relid = 'lab6.hot_longgar'::regclass;

-- Perbandingan ukuran tabel
SELECT
    'hot_penuh' AS tabel,
    pg_size_pretty(pg_total_relation_size('lab6.hot_penuh')) AS ukuran
UNION ALL
SELECT
    'hot_longgar' AS tabel,
    pg_size_pretty(pg_total_relation_size('lab6.hot_longgar')) AS ukuran;