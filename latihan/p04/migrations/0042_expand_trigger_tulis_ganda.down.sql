-- Diminta: membatalkan migration 0042.
-- Dipilih: menghapus trigger dan function dual-write.
-- Alternatif: menghapus tabel harga_film, tetapi tidak dipilih karena tabel tersebut dibuat oleh migration 0041.


DROP TRIGGER IF EXISTS film_dual_write_harga ON lab4.film;

DROP FUNCTION IF EXISTS lab4.fn_dual_write_harga_film();