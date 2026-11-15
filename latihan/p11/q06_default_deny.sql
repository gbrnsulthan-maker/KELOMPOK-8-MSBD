-- Diminta: Mengaktifkan RLS dan membuktikan perilaku "Default Deny" (tanpa policy = gelap gulita).
-- Dipilih: Menambahkan kolom tenant_id (karena setup Novri belum ada), membuat role uji, dan mengaktifkan RLS.
-- Alternatif: Memakai role yang sudah ada; tidak dipilih karena butuh role spesifik buat simulasi kebocoran pool nanti.

-- 1. Tambal Setup: Tambah kolom tenant_id & isi data
ALTER TABLE p11.data_pengujian ADD COLUMN IF NOT EXISTS tenant_id INT;
UPDATE p11.data_pengujian SET tenant_id = 1 WHERE id IN (1, 2);
UPDATE p11.data_pengujian SET tenant_id = 2 WHERE id = 3;

-- 2. Bikin Role Uji (kalau belum ada)
DO $$ BEGIN
  CREATE ROLE rls_tenant_a LOGIN;
  EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  CREATE ROLE rls_tenant_b LOGIN;
  EXCEPTION WHEN duplicate_object THEN null;
END $$;

-- 3. Kasih izin dasar
GRANT USAGE ON SCHEMA p11 TO rls_tenant_a, rls_tenant_b;
GRANT SELECT ON p11.data_pengujian TO rls_tenant_a, rls_tenant_b;

-- 4. Aktifkan RLS (Belum ada policy!)
ALTER TABLE p11.data_pengujian ENABLE ROW LEVEL SECURITY;

-- 5. BUKTI DEFAULT DENY
SET ROLE rls_tenant_a;
SELECT * FROM p11.data_pengujian; 
-- HASIL: 0 baris (walaupun data ada, RLS aktif tapi belum ada aturan = tolak semua)
RESET ROLE;
