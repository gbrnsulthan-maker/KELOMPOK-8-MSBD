# Q11: Tiga Celah Isolasi RLS

1.  **Kebocoran Connection Pool (Context Leak)**
    *   **Masalah:** Pool connection menggunakan kembali sesi yang sama untuk request berbeda. Jika `SET app.tenant_id` tidak di-reset (pakai `DISCARD ALL` atau `RESET`), tenant baru bisa melihat data tenant lama.
    *   **Bukti:** Eksperimen Q10 (Request B melihat data Request A).

2.  **Fungsi SECURITY DEFINER**
    *   **Masalah:** Fungsi PL/pgSQL yang dibuat dengan opsi `SECURITY DEFINER` berjalan menggunakan hak akses pemilik fungsi, bukan pemanggil. Jika pemilik fungsi adalah superuser/owner tabel, RLS policy pemanggil diabaikan.
    *   **Mitigasi:** Hindari `SECURITY DEFINER` kecuali perlu, atau set `SECURITY INVOKER` (default).

3.  **Side-Channel (Timing & Error)**
    *   **Masalah:** Attacker bisa menebak data tersembunyi dari waktu respons query (timing attack) atau pesan error yang detail.
    *   **Contoh:** Query `SELECT 1/0 FROM data WHERE rahasia` bisa error berbeda jika baris ada vs tidak ada.
