# Reflektif B: Kapan RLS Cocok?

**Cocok untuk:**
*   **SaaS Multi-tenant:** Isolasi data pelanggan di database yang sama (hemat biaya infrastruktur).
*   **Audit Trail Otomatis:** Policy bisa memaksa pencatatan siapa akses apa tanpa trigger rumit.

**Tidak Cocok untuk:**
*   **Logika Bisnis Rumit:** Jika aturan akses bergantung pada join 5 tabel atau logika aplikasi yang kompleks, lebih baik di-handle di layer aplikasi (middleware).
*   **Analytics/Reporting:** Query analitik yang butuh akses lintas-tenant akan terhambat policy RLS (harus bypass atau pakai role khusus).
