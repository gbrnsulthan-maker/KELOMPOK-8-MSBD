-- Diminta: menampilkan seluruh bawahan Bima beserta jaraknya dari Bima.
-- Dipilih: Recursive CTE agar seluruh tingkat bawahan dapat ditelusuri.
-- Alternatif: JOIN berulang; tidak dipakai karena jumlah tingkat bawahan dapat berubah.

WITH RECURSIVE bawahan AS (
    SELECT
        pegawai_id,
        nama,
        atasan_id,
        0 AS jarak
    FROM pegawai
    WHERE nama = 'Bima'

    UNION ALL

    SELECT
        p.pegawai_id,
        p.nama,
        p.atasan_id,
        b.jarak + 1
    FROM pegawai p
    JOIN bawahan b
        ON p.atasan_id = b.pegawai_id
)
SELECT
    pegawai_id,
    nama,
    atasan_id,
    jarak
FROM bawahan
WHERE jarak > 0
ORDER BY jarak, nama;