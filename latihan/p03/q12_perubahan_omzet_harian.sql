-- Diminta: menampilkan omzet harian, omzet hari sebelumnya, selisih, dan persentase perubahan.
-- Dipilih: LAG dengan nilai pengganti 0 serta NULLIF agar terhindar dari pembagian dengan nol.
-- Alternatif: self join tabel harian ke dirinya sendiri; tidak dipakai karena LAG lebih ringkas dan jelas.
WITH harian AS (
    SELECT
        payment_date::date AS tanggal,
        SUM(amount) AS omzet
    FROM payment
    GROUP BY payment_date::date
),
perbandingan AS (
    SELECT
        tanggal,
        omzet,
        LAG(omzet, 1, 0) OVER (ORDER BY tanggal) AS omzet_kemarin
    FROM harian
)
SELECT
    tanggal,
    omzet,
    omzet_kemarin,
    omzet - omzet_kemarin AS selisih,
    ROUND(((omzet - omzet_kemarin) / NULLIF(omzet_kemarin, 0) * 100)::numeric, 2) AS persen_perubahan
FROM perbandingan
ORDER BY tanggal;
