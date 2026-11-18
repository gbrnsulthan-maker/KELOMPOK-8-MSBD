-- Diminta: Membuat policy isolasi penyewa berbasis session variable.
-- Dipilih: Policy USING dengan current_setting('app.tenant_id') agar kompatibel dengan connection pool.
-- Alternatif: Hardcode current_user; tidak dipilih karena kurang fleksibel untuk aplikasi SaaS.

CREATE POLICY isolasi_tenant ON p11.data_pengujian
FOR SELECT
USING (tenant_id = current_setting('app.tenant_id', true)::int);

-- UJI COBA
SET app.tenant_id = 1;
SET ROLE rls_tenant_a;
SELECT * FROM p11.data_pengujian; 
-- HASIL: Cuma muncul id 1 & 2 (milik tenant 1)
RESET ROLE;
RESET app.tenant_id;
