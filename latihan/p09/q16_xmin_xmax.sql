-- Diminta: membaca xmin dan xmax serta menjelaskan metadata transaksi.
-- Dipilih: Query langsung ke kolom sistem tersembunyi (xmin, xmax, ctid) untuk membuktikan MVCC.
-- Alternatif: Melihat pg_stat_activity; tidak dipilih karena tidak menunjukkan versi baris.
SELECT 
    xmin AS transaksi_pembuat, 
    xmax AS transaksi_penghapus, 
    ctid AS lokasi_fisik, 
    id, 
    saldo 
FROM p09.rekening 
WHERE id = 1;

-- PENJELASAN:
-- xmin: ID transaksi yang INSERT/UPDATE baris ini (versi ini dibuat oleh transaksi mana).
-- xmax: ID transaksi yang DELETE/UPDATE baris ini (0 jika baris ini masih versi terbaru/aktif).
-- ctid: Alamat fisik baris di halaman disk (File:Page).
