-- 0045_contract_view_fasad.down.sql
-- Rollback tahap facade.
-- Menghapus facade lab4.film dan mengembalikan
-- nama tabel fisik menjadi lab4.film.

DROP VIEW IF EXISTS lab4.film;

ALTER TABLE lab4.film_base
RENAME TO film;
