-- Diminta: menguji domain positive_amount menolak pembayaran 0 dan negatif; catat galat dan SQLSTATE.
-- Dipilih: DO block dengan EXCEPTION agar pesan dan SQLSTATE tertangkap utuh.
-- Alternatif: membaca error mentah psql; tidak dipilih karena SQLSTATE tidak tercetak.
\echo '--- UJI Q6: DOMAIN POSITIVE_AMOUNT ---'
DO $$
DECLARE v_rental bigint;
BEGIN
    -- Pinjam rental_id=1 (asumsi sudah ada dari setup/tes manual)
    -- Atau insert dummy dulu kalau kosong
    INSERT INTO lab5.rental_tx (customer_id, inventory_id, staff_id)
    VALUES (1, 1, 1) RETURNING rental_id INTO v_rental;

    BEGIN
        INSERT INTO lab5.payment_tx (rental_id, amount) VALUES (v_rental, 0);
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'UJI 1 (amount=0) DITOLAK: % | SQLSTATE: %', SQLERRM, SQLSTATE;
    END;

    BEGIN
        INSERT INTO lab5.payment_tx (rental_id, amount) VALUES (v_rental, -4.99);
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'UJI 2 (amount=-4.99) DITOLAK: % | SQLSTATE: %', SQLERRM, SQLSTATE;
    END;
END $$;
