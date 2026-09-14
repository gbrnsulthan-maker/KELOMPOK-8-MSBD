-- Diminta: membatalkan hasil backfill migration 0043.
-- Dipilih: mengosongkan data pada struktur harga baru.
-- Alternatif: menghapus tabel harga_film, tetapi tidak dipilih karena tabel dibuat oleh migration 0041.


TRUNCATE TABLE lab4.harga_film;