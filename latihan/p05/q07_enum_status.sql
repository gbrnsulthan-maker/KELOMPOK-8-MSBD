-- Diminta: menguji enum rental_status menolak EXPIRED, lalu menambahkannya via ALTER TYPE ADD VALUE.
-- Dipilih: UPDATE langsung pada rental_tx (tabel asli) sesuai modul.
-- Alternatif: tabel uji terpisah; tidak dipilih karena modul menguji pada tabel transaksi.
\echo '--- UJI Q7: ENUM RENTAL_STATUS ---'
DO $$
BEGIN
    UPDATE lab5.rental_tx SET status = 'EXPIRED' WHERE rental_id = 1;
EXCEPTION WHEN invalid_text_representation THEN
    RAISE NOTICE 'UJI 1 DITOLAK: % | SQLSTATE: %', SQLERRM, SQLSTATE;
END $$;

ALTER TYPE lab5.rental_status ADD VALUE 'EXPIRED';
UPDATE lab5.rental_tx SET status = 'EXPIRED' WHERE rental_id = 1;
SELECT rental_id, status FROM lab5.rental_tx WHERE rental_id = 1;
