-- Diminta: membuat query dasar ringkasan akses per bulan dan channel.
-- Dipilih: GROUP BY bulan dan kanal dengan COUNT akses serta COUNT DISTINCT film.
-- Alternatif: menggunakan subquery bertingkat, tetapi tidak dipilih karena GROUP BY lebih langsung.

\timing on

SELECT
    date_trunc('month', waktu) AS bulan,
    kanal,
    COUNT(*) AS jumlah_akses,
    COUNT(DISTINCT film_id) AS jumlah_film
FROM lab4.jejak_akses
GROUP BY
    date_trunc('month', waktu),
    kanal
ORDER BY
    bulan,
    kanal;