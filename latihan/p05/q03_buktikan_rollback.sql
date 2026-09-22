-- Q3: Membuktikan rollback ketika payment gagal

SELECT count(*) AS jumlah_sebelum
FROM lab5.rental_tx;

CALL lab5.process_rental(2, 1, 1, -4.99);

SELECT count(*) AS jumlah_sesudah
FROM lab5.rental_tx;

SELECT *
FROM lab5.rental_tx
WHERE rental_id = 2;