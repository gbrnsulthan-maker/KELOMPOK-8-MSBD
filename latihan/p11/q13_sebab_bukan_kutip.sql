-- Q13: payload pembanding

-- Payload 1: zz' OR '1'='1
SELECT id, nama, kota FROM lab11.pelanggan WHERE nama ILIKE '%zz' OR '1'='1%' LIMIT 100;
-- jumlah baris: <isi dari terminalmu>

-- Payload 2: zz' OR '1'='1' --
SELECT id, nama, kota FROM lab11.pelanggan WHERE nama ILIKE '%zz' OR '1'='1' --%' LIMIT 100
;
-- jumlah baris: 1000