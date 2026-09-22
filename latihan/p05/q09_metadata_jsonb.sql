-- Diminta: menyimpan metadata JSONB pada rental_tx dan mengambil channel memakai operator JSONB.
-- Dipilih: operator ->> yang mengembalikan text sesuai modul.
-- Alternatif: operator ->; tidak dipilih karena menghasilkan jsonb, bukan teks.
\echo '--- UJI Q9: METADATA JSONB ---'
UPDATE lab5.rental_tx SET metadata = '{"channel":"web","device":"android"}'::jsonb WHERE rental_id = 1;
SELECT rental_id, metadata ->> 'channel' AS kanal FROM lab5.rental_tx WHERE rental_id = 1;
