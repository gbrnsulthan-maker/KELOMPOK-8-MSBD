-- P06 Q00 - Setup

CREATE SCHEMA IF NOT EXISTS lab6;

DROP TABLE IF EXISTS lab6.event_log;

CREATE TABLE lab6.event_log (
    event_id bigint PRIMARY KEY,
    customer_id integer NOT NULL,
    terjadi_pada timestamptz NOT NULL,
    status text NOT NULL,
    wilayah text NOT NULL,
    kota text NOT NULL,
    email text NOT NULL,
    idempotency_key uuid NOT NULL,
    jumlah numeric(12,2) NOT NULL,
    tags text[] NOT NULL,
    payload jsonb NOT NULL
);

-- Membuat 2.000.000 data
INSERT INTO lab6.event_log (
    event_id,
    customer_id,
    terjadi_pada,
    status,
    wilayah,
    kota,
    email,
    idempotency_key,
    jumlah,
    tags,
    payload
)
SELECT
    gs,
    ((gs - 1) % 10000) + 1,
    timestamptz '2024-01-01 00:00:00+07'
        + ((gs - 1) % 365) * interval '1 day'
        + ((gs - 1) % 86400) * interval '1 second',
    CASE
        WHEN gs % 10 < 7 THEN 'SUKSES'
        WHEN gs % 10 < 9 THEN 'GAGAL'
        ELSE 'TERTUNDA'
    END,
    CASE
        WHEN gs % 5 = 0 THEN 'SUMATERA UTARA'
        WHEN gs % 5 = 1 THEN 'JAWA BARAT'
        WHEN gs % 5 = 2 THEN 'JAWA TIMUR'
        WHEN gs % 5 = 3 THEN 'DKI JAKARTA'
        ELSE 'SUMATERA BARAT'
    END,
    CASE
        WHEN gs % 5 = 0 THEN 'Medan'
        WHEN gs % 5 = 1 THEN 'Bandung'
        WHEN gs % 5 = 2 THEN 'Surabaya'
        WHEN gs % 5 = 3 THEN 'Jakarta'
        ELSE 'Padang'
    END,
    'user' || (((gs - 1) % 10000) + 1) || '@example.com',
    gen_random_uuid(),
    round((10 + random() * 990)::numeric, 2),
    ARRAY[
        'kanal:' || (((gs - 1) % 5) + 1),
        CASE
            WHEN gs % 2 = 0 THEN 'mobile'
            ELSE 'web'
        END
    ],
    jsonb_build_object(
        'promo', gs % 10 = 0,
        'source',
            CASE
                WHEN gs % 2 = 0 THEN 'mobile'
                ELSE 'web'
            END,
        'nilai', gs % 100
    )
FROM generate_series(1, 2000000) AS gs;

ANALYZE lab6.event_log;

-- Bukti jumlah data
SELECT count(*) AS jumlah_baris
FROM lab6.event_log;

-- Ukuran tabel
SELECT
    pg_size_pretty(pg_total_relation_size('lab6.event_log')) AS ukuran_total,
    pg_total_relation_size('lab6.event_log') AS ukuran_total_bytes;

-- PostgreSQL version
SELECT version();

-- Kondisi mesin / setting parallel
SHOW max_parallel_workers_per_gather;