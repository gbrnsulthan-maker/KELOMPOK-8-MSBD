-- Migration 0044: Verifikasi hasil backfill
-- Diminta: memastikan semua film sudah memiliki data harga baru.
-- Verifikasi harus menghasilkan 0.

SELECT COUNT(*) AS film_belum_memiliki_harga
FROM lab4.film f
LEFT JOIN lab4.harga_film hf
    ON hf.film_id = f.film_id
WHERE hf.film_id IS NULL;