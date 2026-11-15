-- Diminta: Menguji FORCE RLS (owner kena filter) dan BYPASSRLS (role auditor bebas).
-- Dipilih: Memakai owner non-superuser (p11_owner) karena superuser kebal FORCE RLS.
-- Alternatif: Tes sebagai msbd; tidak dipilih karena msbd superuser sehingga demo gagal.

-- 1. Bikin owner non-superuser buat demo FORCE
DO $$ BEGIN
  CREATE ROLE p11_owner LOGIN;
  EXCEPTION WHEN duplicate_object THEN null;
END $$;
GRANT USAGE ON SCHEMA p11 TO p11_owner;
GRANT ALL ON p11.data_pengujian TO p11_owner;
ALTER TABLE p11.data_pengujian OWNER TO p11_owner;

-- 2. TANPA FORCE: owner bebas dari RLS
SET ROLE p11_owner;
SELECT count(*) AS owner_tanpa_force FROM p11.data_pengujian;   -- harapannya 3
RESET ROLE;

-- 3. DENGAN FORCE: owner pun kena policy
ALTER TABLE p11.data_pengujian FORCE ROW LEVEL SECURITY;
SET app.tenant_id = 1;
SET ROLE p11_owner;
SELECT count(*) AS owner_dengan_force FROM p11.data_pengujian;  -- harapannya 2
RESET ROLE;
RESET app.tenant_id;
ALTER TABLE p11.data_pengujian NO FORCE ROW LEVEL SECURITY;

-- 4. BYPASSRLS: auditor melompati semua policy
DO $$ BEGIN
  CREATE ROLE rls_auditor LOGIN BYPASSRLS;
  EXCEPTION WHEN duplicate_object THEN null;
END $$;
GRANT USAGE ON SCHEMA p11 TO rls_auditor;
GRANT SELECT ON p11.data_pengujian TO rls_auditor;
SET ROLE rls_auditor;
SELECT count(*) AS auditor_bypassrls FROM p11.data_pengujian;   -- harapannya 3
RESET ROLE;

-- 5. Kembalikan kepemilikan ke msbd biar aman buat Limjun & Ghibran
ALTER TABLE p11.data_pengujian OWNER TO msbd;
