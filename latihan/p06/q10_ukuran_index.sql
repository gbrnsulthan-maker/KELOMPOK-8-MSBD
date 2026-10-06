-- Diminta: membandingkan ukuran fisik ev_salah_idx dan ev_benar_idx.
-- Dipilih: pg_relation_size lewat pg_stat_user_indexes karena langsung menunjukkan ukuran fisik tiap index di skema lab6.
-- Alternatif: pg_total_relation_size; tidak dipilih karena lebih relevan untuk tabel beserta TOAST-nya.
-- Catatan: ev_salah_idx dibuat ulang di sini (sudah di-drop pada Q9) dan keduanya dibiarkan ada untuk eksperimen berikutnya.
CREATE INDEX IF NOT EXISTS ev_salah_idx
ON lab6.event_log (terjadi_pada, customer_id);

SELECT indexrelname AS nama_index,
       pg_size_pretty(pg_relation_size(indexrelid)) AS ukuran,
       pg_relation_size(indexrelid) AS bytes
FROM pg_stat_user_indexes
WHERE schemaname = 'lab6'
ORDER BY pg_relation_size(indexrelid) DESC;
