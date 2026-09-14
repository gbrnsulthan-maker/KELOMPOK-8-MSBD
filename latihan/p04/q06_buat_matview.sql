-- Diminta: membuat materialized view dari query ringkasan akses Q5.
-- Dipilih: menggunakan WITH NO DATA lalu melakukan REFRESH secara manual.
-- Alternatif: membuat materialized view langsung terisi, tetapi tidak dipilih karena tugas meminta pengujian WITH NO DATA.

CREATE MATERIALIZED VIEW lab4.ringkasan_akses AS
SELECT
    date_trunc('month', waktu) AS bulan,
    kanal,
    COUNT(*) AS jumlah_akses,
    COUNT(DISTINCT film_id) AS jumlah_film
FROM lab4.jejak_akses
GROUP BY
    date_trunc('month', waktu),
    kanal
WITH NO DATA;


-- Percobaan SELECT sebelum REFRESH.
-- Seharusnya menghasilkan error karena materialized view belum terisi.

SELECT *
FROM lab4.ringkasan_akses;


-- Isi materialized view.

\timing on

REFRESH MATERIALIZED VIEW lab4.ringkasan_akses;


-- Verifikasi setelah REFRESH.

SELECT *
FROM lab4.ringkasan_akses
ORDER BY bulan, kanal;