-- Q27: Perbandingan INSERT tanpa index dan dengan 5 index

SET max_parallel_workers_per_gather = 0;

DROP TABLE IF EXISTS lab6.event_log_insert_noidx;
DROP TABLE IF EXISTS lab6.event_log_insert_idx;

-- Tabel tanpa index tambahan
CREATE TABLE lab6.event_log_insert_noidx
(LIKE lab6.event_log INCLUDING DEFAULTS);

-- Tabel dengan 5 index
CREATE TABLE lab6.event_log_insert_idx
(LIKE lab6.event_log INCLUDING DEFAULTS);

CREATE INDEX q27_idx_1
ON lab6.event_log_insert_idx (customer_id);

CREATE INDEX q27_idx_2
ON lab6.event_log_insert_idx (status);

CREATE INDEX q27_idx_3
ON lab6.event_log_insert_idx (terjadi_pada);

CREATE INDEX q27_idx_4
ON lab6.event_log_insert_idx (wilayah, kota);

CREATE INDEX q27_idx_5
ON lab6.event_log_insert_idx (lower(email));

-- INSERT 200.000 baris ke tabel tanpa index
\timing on

INSERT INTO lab6.event_log_insert_noidx
SELECT *
FROM lab6.event_log
WHERE event_id <= 200000;

-- INSERT 200.000 baris ke tabel dengan 5 index
INSERT INTO lab6.event_log_insert_idx
SELECT *
FROM lab6.event_log
WHERE event_id <= 200000;

\timing off