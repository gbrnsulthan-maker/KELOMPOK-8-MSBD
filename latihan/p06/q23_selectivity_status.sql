-- Q23: Selectivity status dan perubahan strategi scan

SELECT
    status,
    COUNT(*) AS jumlah,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM lab6.event_log),
        2
    ) AS persentase
FROM lab6.event_log
GROUP BY status
ORDER BY jumlah DESC;

-- Pengujian SUKSES (70%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'SUKSES';

-- Pengujian GAGAL (20%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'GAGAL';

-- Pengujian TERTUNDA (10%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'TERTUNDA';