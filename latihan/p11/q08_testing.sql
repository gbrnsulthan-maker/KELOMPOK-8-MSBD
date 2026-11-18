-- Diminta: Pengujian positif (lihat data sendiri) dan negatif (tidak bisa lihat data orang).

-- POSITIF: Tenant 2 lihat data sendiri
SET app.tenant_id = 2;
SET ROLE rls_tenant_b;
SELECT * FROM p11.data_pengujian; 
-- HASIL: Cuma muncul id 3
RESET ROLE;
RESET app.tenant_id;

-- NEGATIF: Tenant 1 coba intip data Tenant 2 (pakai WHERE paksa)
SET app.tenant_id = 1;
SET ROLE rls_tenant_a;
SELECT * FROM p11.data_pengujian WHERE tenant_id = 2; 
-- HASIL: 0 baris (Policy memblokir sebelum WHERE dievaluasi)
RESET ROLE;
RESET app.tenant_id;
