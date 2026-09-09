-- Diminta: menampilkan urutan pembayaran, jarak hari sejak pembayaran sebelumnya, dan total belanja per pelanggan.
-- Dipilih: PARTITION BY customer_id dengan ROW_NUMBER, LAG, dan SUM berframe seluruh partisi.
-- Alternatif: self join per pelanggan; tidak dipakai karena jauh lebih rumit dan lambat.
WITH riwayat AS (
    SELECT
        customer_id,
        payment_id,
        payment_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY payment_date, payment_id
        ) AS urutan,
        LAG(payment_date) OVER (
            PARTITION BY customer_id
            ORDER BY payment_date, payment_id
        ) AS pembayaran_sebelumnya,
        SUM(amount) OVER (
            PARTITION BY customer_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS total_belanja
    FROM payment
)
SELECT
    customer_id,
    payment_id,
    payment_date,
    amount,
    urutan,
    pembayaran_sebelumnya,
    payment_date::date - pembayaran_sebelumnya::date AS jarak_hari,
    total_belanja
FROM riwayat
ORDER BY customer_id, urutan;
