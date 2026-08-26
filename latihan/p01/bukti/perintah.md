# Perintah Praktikum 01

## 1. Verifikasi Docker

docker --version

docker compose version

docker run --rm hello-world

## 2. Menjalankan Docker Compose

docker compose up -d

docker compose ps

docker compose logs postgres

## 3. Masuk ke PostgreSQL

docker compose exec postgres psql -U msbd -d latihan

## 4. Perintah Dasar psql

SELECT version();

\l

\dt

\dn

\du

SHOW data_directory;

SHOW shared_buffers;

\timing on

\q

## 5. Mengecek Tabel Setelah Restore Pagila

docker compose exec postgres psql -U msbd -d latihan -c "\dt"

## 6. Query Verifikasi

Query V1 sampai V4 disimpan pada file:

latihan/p01/verifikasi.sql

## 7. Git

git status

git add

git commit

git pull

git push