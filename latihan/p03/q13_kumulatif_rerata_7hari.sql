-- Diminta: menampilkan omzet harian beserta total kumulatif dan rata-rata bergerak tujuh hari.
-- Dipilih: dua window function dengan frame ROWS eksplisit yang berbeda.
-- Alternatif: membiarkan frame default RANGE; tidak dipakai karena dapat menyertakan peer dan membuat kumulatif melompat.
WITH harian AS (
    SELECT
        payment_date::date AS tanggal,
        SUM(amount) AS omzet
    FROM payment
    GROUP BY payment_date::date
)
SELECT
    tanggal,
    omzet,
    SUM(omzet) OVER (
        ORDER BY tanggal
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS omzet_kumulatif,
    AVG(omzet) OVER (
        ORDER BY tanggal
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rata_rata_7_hari
FROM harian
ORDER BY tanggal;
