CREATE TABLE petugas (
    id_petugas bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nomor_petugas varchar(16) NOT NULL UNIQUE,
    nama varchar(120) NOT NULL,
    email varchar(120) UNIQUE,
    status varchar(16) NOT NULL DEFAULT 'aktif'
        CHECK (status IN ('aktif','nonaktif'))
);

CREATE TABLE peminjaman (
    id_peminjaman bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_anggota bigint NOT NULL REFERENCES anggota(id_anggota),
    id_petugas bigint REFERENCES petugas(id_petugas),
    tgl_pinjam date NOT NULL DEFAULT current_date,
    jatuh_tempo date NOT NULL,
    tgl_kembali date,
    status varchar(16) NOT NULL DEFAULT 'aktif'
        CHECK (status IN ('aktif','selesai','terlambat')),
    CONSTRAINT ck_pinjam_tempo CHECK (jatuh_tempo >= tgl_pinjam)
);

CREATE TABLE detail_peminjaman (
    id_peminjaman bigint NOT NULL REFERENCES peminjaman(id_peminjaman),
    id_unit bigint NOT NULL REFERENCES unit_alat(id_unit),
    kondisi_saat_pinjam varchar(20) NOT NULL,
    PRIMARY KEY (id_peminjaman, id_unit)
);

CREATE TABLE perbaikan (
    id_perbaikan bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_unit bigint NOT NULL REFERENCES unit_alat(id_unit),
    tanggal_mulai date NOT NULL DEFAULT current_date,
    tanggal_selesai date,
    keterangan text,
    status varchar(16) NOT NULL DEFAULT 'proses'
        CHECK (status IN ('proses','selesai'))
);

CREATE TABLE peran (
    id_peran bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kode varchar(10) NOT NULL UNIQUE,
    nama varchar(120) NOT NULL
);
