-- Diminta: membuktikan pembaca tetap dapat mengakses materialized view
-- saat REFRESH MATERIALIZED VIEW CONCURRENTLY berlangsung dan membandingkannya
-- dengan REFRESH MATERIALIZED VIEW biasa.
-- Dipilih: menggunakan dua sesi PostgreSQL, 200.000 data tambahan, dan mencatat waktu refresh.
-- Alternatif: menggunakan satu sesi saja, tetapi tidak dapat menguji akses pembaca secara terpisah.


-- =========================================================
-- SESI 1: Tambahkan 200.000 data akses
-- =========================================================

INSERT INTO lab4.jejak_akses (film_id, waktu, kanal)
SELECT
    ((g - 1) % 1000) + 1,
    CURRENT_TIMESTAMP - ((g % 365) * INTERVAL '1 day'),
    CASE (g % 4)
        WHEN 0 THEN 'web'
        WHEN 1 THEN 'android'
        WHEN 2 THEN 'ios'
        ELSE 'kiosk'
    END
FROM generate_series(1, 200000) AS g;


-- =========================================================
-- SESI 1: Refresh menggunakan CONCURRENTLY
-- =========================================================

\timing on

REFRESH MATERIALIZED VIEW CONCURRENTLY lab4.ringkasan_akses;


-- =========================================================
-- SESI 2: Verifikasi pembaca dapat mengakses MV
-- =========================================================

-- Jalankan SELECT berikut dari sesi PostgreSQL kedua
-- ketika refresh concurrent sedang berlangsung:
--
-- SELECT count(*) FROM lab4.ringkasan_akses;
--
-- Hasil pengujian:
-- count = 52


-- =========================================================
-- SESI 1: Refresh normal sebagai pembanding
-- =========================================================

REFRESH MATERIALIZED VIEW lab4.ringkasan_akses;


-- Hasil pengujian aktual:
-- CONCURRENTLY : 2887.184 ms
-- NORMAL       : 2161.600 ms
-- SELECT count(*) saat concurrent refresh : 52 baris