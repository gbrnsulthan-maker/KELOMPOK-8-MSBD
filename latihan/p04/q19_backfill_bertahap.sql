-- Diminta: Melakukan backfill data harga dari struktur lama
--          ke struktur baru secara bertahap, kemudian memastikan
--          seluruh film sudah berhasil dimigrasikan.
-- Dipilih: Backfill berdasarkan rentang film_id 1 sampai 1000
--          dengan NOT EXISTS agar data yang sudah masuk melalui
--          dual-write tidak dimasukkan kembali.
-- Alternatif: INSERT seluruh data tanpa pengecekan tidak dipakai
--             karena dapat menyebabkan konflik pada data yang
--             sudah lebih dahulu masuk melalui dual-write.

-- =========================================================
-- Q19 - BACKFILL BERTAHAP
-- =========================================================

INSERT INTO lab4.harga_film (film_id, wilayah, harga, berlaku)
SELECT
    f.film_id,
    'ID',
    f.rental_rate,
    daterange('2026-01-01', NULL)
FROM lab4.film f
WHERE f.film_id BETWEEN 1 AND 1000
  AND NOT EXISTS (
      SELECT 1
      FROM lab4.harga_film h
      WHERE h.film_id = f.film_id
        AND h.wilayah = 'ID'
  );

-- =========================================================
-- VERIFIKASI
-- Hasil harus 0 sebelum proses contract pada Q20 dilakukan.
-- =========================================================

SELECT count(*) AS film_belum_dimigrasi
FROM lab4.film f
WHERE NOT EXISTS (
    SELECT 1
    FROM lab4.harga_film h
    WHERE h.film_id = f.film_id
      AND h.wilayah = 'ID'
);