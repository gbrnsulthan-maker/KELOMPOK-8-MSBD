CREATE TABLE anggota (
    id_anggota bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nomor_anggota varchar(16) NOT NULL UNIQUE,
    nama varchar(120) NOT NULL,
    status varchar(16) NOT NULL DEFAULT 'aktif'
        CHECK (status IN ('aktif','ditangguhkan','keluar')),
    tgl_bergabung date NOT NULL DEFAULT current_date
);

CREATE TABLE kategori ( 
    id_kategori bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    kode_kategori varchar(16) NOT NULL UNIQUE, 
    nama_kategori varchar(120) NOT NULL, 
    deskripsi text 
); 

CREATE TABLE alat ( 
    id_alat bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    kode_alat varchar(16) NOT NULL UNIQUE, 
    nama varchar(120) NOT NULL, 
    id_kategori bigint NOT NULL 
        REFERENCES kategori(id_kategori), 
    deskripsi text 
);

CREATE TABLE unit_alat ( 
    id_unit bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    kode_unit varchar(20) NOT NULL UNIQUE, 
    id_alat bigint NOT NULL 
        REFERENCES alat(id_alat), 
    kondisi varchar(20) NOT NULL DEFAULT 'baik' 
        CHECK (kondisi IN ('baik','rusak_ringan','rusak')), 
     status_ketersediaan varchar(20) NOT NULL DEFAULT 'tersedia' 
        CHECK (status_ketersediaan IN ('tersedia','dipinjam','perbaikan')) 
);

