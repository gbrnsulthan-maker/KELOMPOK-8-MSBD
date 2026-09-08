-- Diminta: mencari pelanggan yang pernah melakukan pembayaran lebih dari 9.99.
-- Dipilih: EXISTS berkorelasi karena hanya perlu membuktikan keberadaan transaksi.
-- Alternatif: JOIN + DISTINCT; tidak dipakai karena dapat membuat duplikasi terlebih dahulu.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE EXISTS (
    SELECT 1 FROM payment p
    WHERE p.customer_id = c.customer_id
      AND p.amount > 9.99
)
ORDER BY c.customer_id;
