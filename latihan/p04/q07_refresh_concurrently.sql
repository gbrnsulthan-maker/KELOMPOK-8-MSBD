-- Diminta: menguji REFRESH MATERIALIZED VIEW CONCURRENTLY sebelum dan sesudah unique index.
-- Dipilih: membuat unique index pada seluruh kolom hasil materialized view.
-- Alternatif: menggunakan REFRESH MATERIALIZED VIEW biasa, tetapi tidak dipilih karena soal menguji kebutuhan unique index untuk refresh concurrently.

\timing on

-- Percobaan 1
-- Harus menghasilkan error karena belum ada unique index.

REFRESH MATERIALIZED VIEW CONCURRENTLY lab4.ringkasan_akses;


-- Percobaan 2
-- Buat unique index yang mencakup seluruh kolom hasil materialized view.

CREATE UNIQUE INDEX ringkasan_akses_unique_idx
ON lab4.ringkasan_akses (
    bulan,
    kanal,
    jumlah_akses,
    jumlah_film
);


-- Percobaan 3
-- Setelah unique index dibuat, refresh concurrent harus berhasil.

REFRESH MATERIALIZED VIEW CONCURRENTLY lab4.ringkasan_akses;