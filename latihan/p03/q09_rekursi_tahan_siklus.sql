-- Diminta: membuat Recursive CTE yang aman terhadap siklus pada hierarki pegawai.
-- Dipilih: menggunakan array path untuk mendeteksi pegawai yang sudah dikunjungi.
-- Alternatif: membatasi kedalaman rekursi; tidak dipakai karena tidak benar-benar mendeteksi siklus.

WITH RECURSIVE hierarki AS (
    SELECT
        pegawai_id,
        nama,
        atasan_id,
        0 AS level,
        ARRAY[pegawai_id] AS path
    FROM pegawai
    WHERE pegawai_id = 1

    UNION ALL

    SELECT
        p.pegawai_id,
        p.nama,
        p.atasan_id,
        h.level + 1,
        h.path || p.pegawai_id
    FROM pegawai p
    JOIN hierarki h
        ON p.atasan_id = h.pegawai_id
    WHERE NOT (p.pegawai_id = ANY(h.path))
)
SELECT
    pegawai_id,
    nama,
    atasan_id,
    level,
    path
FROM hierarki
ORDER BY level, pegawai_id;