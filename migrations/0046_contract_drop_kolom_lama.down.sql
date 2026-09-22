-- 0046_contract_drop_kolom_lama.down.sql
-- Rollback tahap penghapusan bentuk lama.
--
-- PERINGATAN:
-- Migration ini dapat membuat kembali kolom rental_rate,
-- tetapi nilai lama yang sudah dihapus tidak dapat dipulihkan
-- secara penuh hanya dari operasi DROP COLUMN.
--
-- Nilai rental_rate diisi kembali dari harga_film wilayah ID
-- sebagai rekonstruksi dari struktur harga baru.

ALTER TABLE lab4.film_base
ADD COLUMN rental_rate numeric(4,2);

UPDATE lab4.film_base f
SET rental_rate = h.harga
FROM lab4.harga_film h
WHERE h.film_id = f.film_id
  AND h.wilayah = 'ID';

-- Dual-write tidak dipasang kembali di sini.
-- Jika sistem benar-benar dikembalikan ke fase expand,
-- trigger harus dipulihkan melalui rollback migration
-- yang mengatur dual-write.