-- Q2 - Tuple per Page

-- Jumlah tuple per page berdasarkan CTID
SELECT
    (ctid::text::point)[0] AS block,
    count(*) AS jumlah_tuple
FROM lab6.event_log
GROUP BY block
ORDER BY block
LIMIT 20;

-- Rata-rata tuple per page
SELECT
    count(*)::numeric
    / count(DISTINCT (ctid::text::point)[0]) AS rata_rata_tuple_per_page
FROM lab6.event_log;

-- Jumlah page yang digunakan
SELECT
    count(DISTINCT (ctid::text::point)[0]) AS jumlah_page
FROM lab6.event_log;