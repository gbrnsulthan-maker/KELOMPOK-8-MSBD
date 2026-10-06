-- Q12 - Perbandingan Partial Index dan Index Polos

-- 1. Buat index polos pada kolom terjadi_pada untuk perbandingan
CREATE INDEX IF NOT EXISTS ev_polos_idx ON lab6.event_log (terjadi_pada);

-- 2. Hitung ukuran kedua index dan persentase penghematannya
SELECT 
    pg_size_pretty(pg_relation_size('lab6.ev_polos_idx')) AS ukuran_index_polos,
    pg_size_pretty(pg_relation_size('lab6.ev_gagal_idx')) AS ukuran_partial_index,
    ROUND(
        (1.0 - (pg_relation_size('lab6.ev_gagal_idx')::numeric / pg_relation_size('lab6.ev_polos_idx')::numeric)) * 100, 
        2
    ) AS persentase_penghematan_persen;