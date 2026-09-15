-- Rollback 0041: Hapus struktur harga_film
DROP TABLE IF EXISTS lab4.harga_film CASCADE;
-- Catatan: Ekstensi btree_gist biasanya dibiarkan saja saat rollback tabel.
