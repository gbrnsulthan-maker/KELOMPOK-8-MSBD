-- Diminta: membandingkan hasil Q13 (frame ROWS eksplisit) dengan versi tanpa frame (RANGE default).
-- Dipilih: EXCEPT untuk menemukan baris tanggal yang hasilnya berbeda, lalu dihitung jumlahnya.
-- Alternatif: membandingkan manual di layar; tidak dipakai karena rawan salah dan tidak reproduktibel.
WITH harian AS (
    SELECT
        payment_date::date AS tanggal,
        SUM(amount) AS omzet
    FROM payment
    GROUP BY payment_date::date
),
versi_rows AS (
    SELECT
        tanggal,
        SUM(omzet) OVER (
            ORDER BY tanggal
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS omzet_kumulatif,
        AVG(omzet) OVER (
            ORDER BY tanggal
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rata_rata_7_hari
    FROM harian
),
versi_range AS (
    SELECT
        tanggal,
        SUM(omzet) OVER (
            ORDER BY tanggal
        ) AS omzet_kumulatif,
        AVG(omzet) OVER (
            ORDER BY tanggal
        ) AS rata_rata_7_hari
    FROM harian
)
SELECT count(*) AS jumlah_tanggal_berbeda
FROM (
    SELECT tanggal, omzet_kumulatif, rata_rata_7_hari FROM versi_rows
    EXCEPT
    SELECT tanggal, omzet_kumulatif, rata_rata_7_hari FROM versi_range
) AS selisih;

-- Daftar contoh tanggal yang berbeda (bahan penjelasan laporan):
WITH harian AS (
    SELECT
        payment_date::date AS tanggal,
        SUM(amount) AS omzet
    FROM payment
    GROUP BY payment_date::date
),
versi_rows AS (
    SELECT
        tanggal,
        SUM(omzet) OVER (
            ORDER BY tanggal
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS omzet_kumulatif,
        AVG(omzet) OVER (
            ORDER BY tanggal
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rata_rata_7_hari
    FROM harian
),
versi_range AS (
    SELECT
        tanggal,
        SUM(omzet) OVER (
            ORDER BY tanggal
        ) AS omzet_kumulatif,
        AVG(omzet) OVER (
            ORDER BY tanggal
        ) AS rata_rata_7_hari
    FROM harian
)
SELECT r.tanggal,
       r.omzet_kumulatif AS kum_rows,
       g.omzet_kumulatif AS kum_range,
       r.rata_rata_7_hari AS rata_rows,
       g.rata_rata_7_hari AS rata_range
FROM versi_rows r
JOIN versi_range g USING (tanggal)
WHERE r.omzet_kumulatif IS DISTINCT FROM g.omzet_kumulatif
   OR r.rata_rata_7_hari IS DISTINCT FROM g.rata_rata_7_hari
ORDER BY r.tanggal
LIMIT 10;
