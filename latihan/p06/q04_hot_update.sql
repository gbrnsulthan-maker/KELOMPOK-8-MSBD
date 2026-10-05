-- Q4 - HOT Update

DROP TABLE IF EXISTS lab6.hot_test;

CREATE TABLE lab6.hot_test (
    id serial PRIMARY KEY,
    nama text,
    keterangan text
);

INSERT INTO lab6.hot_test (nama, keterangan)
SELECT
    'Nama ' || gs,
    'Keterangan awal ' || gs
FROM generate_series(1, 100000) AS gs;

ANALYZE lab6.hot_test;

-- Update kolom yang tidak memiliki index
UPDATE lab6.hot_test
SET keterangan = keterangan || ' updated';

-- Statistik HOT update
SELECT
    n_tup_upd,
    n_tup_hot_upd
FROM pg_stat_all_tables
WHERE relid = 'lab6.hot_test'::regclass;