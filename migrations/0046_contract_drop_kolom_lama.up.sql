-- 0046_contract_drop_kolom_lama.up.sql
-- Tahap contract terakhir.
-- Dual-write dihentikan dan kolom rental_rate lama
-- pada tabel fisik dihapus setelah facade tersedia.

-- Hentikan dual-write pada tabel fisik.
DROP TRIGGER IF EXISTS trg_sync_harga_film
ON lab4.film_base;

DROP FUNCTION IF EXISTS lab4.sync_harga_film();

-- Hapus bentuk harga lama.
ALTER TABLE lab4.film_base
DROP COLUMN rental_rate;