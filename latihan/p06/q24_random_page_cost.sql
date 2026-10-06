-- Q24: Pengaruh random_page_cost terhadap pemilihan plan

SET max_parallel_workers_per_gather = 0;

SET random_page_cost = 1.1;

-- Status SUKSES (70%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'SUKSES';

-- Status GAGAL (20%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'GAGAL';

-- Status TERTUNDA (10%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM lab6.event_log
WHERE status = 'TERTUNDA';

-- Kembalikan ke nilai default/session sebelumnya
RESET random_page_cost;