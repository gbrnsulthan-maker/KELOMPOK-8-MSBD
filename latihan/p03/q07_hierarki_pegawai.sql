-- Diminta: membuat hierarki pegawai dari atasan sampai bawahan menggunakan Recursive CTE.
-- Dipilih: Recursive CTE agar hubungan atasan dan bawahan dapat ditelusuri bertingkat.
-- Alternatif: JOIN berulang; tidak dipakai karena jumlah tingkat hierarki dapat berubah.

WITH RECURSIVE hierarki AS (
    SELECT
        pegawai_id,
        nama,
        atasan_id,
        0 AS level,
        nama::text AS jalur
    FROM pegawai
    WHERE atasan_id IS NULL

    UNION ALL

    SELECT
        p.pegawai_id,
        p.nama,
        p.atasan_id,
        h.level + 1,
        h.jalur || ' > ' || p.nama
    FROM pegawai p
    JOIN hierarki h
        ON p.atasan_id = h.pegawai_id
)
SELECT
    pegawai_id,
    nama,
    atasan_id,
    level,
    jalur
FROM hierarki
ORDER BY jalur;