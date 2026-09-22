-- Diminta: mengisi tags array pada rental_tx dan mencari baris dengan tag tertentu memakai ANY.
-- Dipilih: UPDATE pada rental_tx sesuai modul, lalu filter 'promo' = ANY(tags).
-- Alternatif: tabel relasi terpisah; tidak dipilih karena modul memakai kolom array langsung.
\echo '--- UJI Q8: TAGS ARRAY ---'
UPDATE lab5.rental_tx SET tags = ARRAY['promo','akhir-pekan','anggota'] WHERE rental_id = 1;
SELECT rental_id, tags FROM lab5.rental_tx WHERE 'promo' = ANY(tags);
