-- Diminta: membandingkan biaya UPDATE massal dengan trigger aktif dan trigger dinonaktifkan.
-- Dipilih: menggunakan \timing untuk mencatat waktu eksekusi secara nyata.
-- Alternatif: memperkirakan biaya berdasarkan jumlah baris, tetapi tidak dipilih karena tugas meminta waktu eksekusi aktual.


\timing on


-- UPDATE massal dengan trigger aktif
UPDATE lab4.film
SET rental_rate = rental_rate + 0.01;


-- Nonaktifkan trigger
ALTER TABLE lab4.film
DISABLE TRIGGER film_audit_harga;


-- UPDATE massal tanpa trigger
UPDATE lab4.film
SET rental_rate = rental_rate - 0.01;


-- Aktifkan kembali trigger
ALTER TABLE lab4.film
ENABLE TRIGGER film_audit_harga;