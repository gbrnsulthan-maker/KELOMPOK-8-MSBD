-- Diminta: Simulasi kebocoran data di connection pool karena lupa reset context.
-- Skenario: Request A (Tenant 1) selesai tapi context nggak di-reset. Request B (Tenant 2) masuk pakai koneksi yang sama.

-- [REQUEST 1: Tenant A]
SET app.tenant_id = 1;
SET ROLE rls_tenant_a;
SELECT 'Request A (Tenant 1)' AS sesi, count(*) FROM p11.data_pengujian;
RESET ROLE;
-- (Aplikasi lupa jalankan RESET app.tenant_id!)

-- [REQUEST 2: Tenant B masuk ke koneksi yang sama]
SET ROLE rls_tenant_b;
-- Asumsi aplikasi Tenant B nggak set app.tenant_id (bug)
SELECT 'Request B (Harusnya Tenant 2)' AS sesi, count(*) FROM p11.data_pengujian;
-- HASIL: Masih muncul 2 baris (data Tenant 1)! 😱
-- Ini karena app.tenant_id masih nyimpen nilai '1' dari request sebelumnya.

RESET ROLE;
RESET app.tenant_id;
