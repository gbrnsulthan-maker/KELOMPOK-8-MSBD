-- Q28: Perbandingan ukuran tabel tanpa index dan dengan 5 index

SELECT
    'tanpa_index' AS kondisi,
    pg_size_pretty(
        pg_total_relation_size('lab6.event_log_insert_noidx')
    ) AS ukuran,
    pg_total_relation_size(
        'lab6.event_log_insert_noidx'
    ) AS ukuran_bytes

UNION ALL

SELECT
    'dengan_5_index' AS kondisi,
    pg_size_pretty(
        pg_total_relation_size('lab6.event_log_insert_idx')
    ) AS ukuran,
    pg_total_relation_size(
        'lab6.event_log_insert_idx'
    ) AS ukuran_bytes;