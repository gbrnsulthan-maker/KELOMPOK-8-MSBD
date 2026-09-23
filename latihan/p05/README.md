# Latihan Pertemuan 5 - MSBD

Latihan ini membahas implementasi PostgreSQL menggunakan PL/pgSQL, tipe data PostgreSQL, psycopg 3, SQLAlchemy ORM, dan FastAPI.

## Anggota Kelompok

- Ghibran Sultan Alfarabi
- Novri
- Limjun
- Bintang

## Prasyarat

Pastikan sudah menginstal:

- Python 3
- PostgreSQL
- psycopg 3
- SQLAlchemy
- FastAPI
- Uvicorn

Install library Python yang diperlukan:

```bash
python -m pip install psycopg[binary] sqlalchemy fastapi uvicorn
```

## Konfigurasi Database

Database yang digunakan adalah `pagila`.

Format DSN untuk psycopg:

```text
postgresql://USERNAME:PASSWORD@localhost:5432/pagila
```

Format DSN untuk SQLAlchemy:

```text
postgresql+psycopg://USERNAME:PASSWORD@localhost:5432/pagila
```

Sesuaikan `USERNAME` dan `PASSWORD` dengan konfigurasi PostgreSQL masing-masing.

## Struktur Latihan

File Pertemuan 5 berada pada:

```text
latihan/p05/
```

File utama yang digunakan:

```text
lab5_driver.py
lab5_orm.py
lab5_api.py
q01_setup_lab5.sql
q02_process_rental.sql
q03_buktikan_rollback.sql
q04_commit_dalam_procedure.sql
q05_exception_fk.sql
q06_domain_positive_amount.sql
q07_enum_status.sql
q08_tags_array.sql
q09_metadata_jsonb.sql
```

## Menjalankan Driver psycopg

Jalankan:

```bash
python latihan/p05/lab5_driver.py
```

Driver digunakan untuk pengujian psycopg, parameter binding, transaksi, dan connection pool.

## Menjalankan SQLAlchemy ORM

Jalankan:

```bash
python latihan/p05/lab5_orm.py
```

Program menyediakan pengujian:

1. Q17 - N+1 Query
2. Q18 - selectinload
3. Q19 - joinedload
4. Q20 - ORM vs Raw SQL
5. Menjalankan seluruh pengujian

## Menjalankan FastAPI

Jalankan server menggunakan:

```bash
uvicorn latihan.p05.lab5_api:app --reload
```

Server berjalan pada:

```text
http://127.0.0.1:8000
```

Dokumentasi API tersedia pada:

```text
http://127.0.0.1:8000/docs
```

## Q22 - Membuat Rental

Endpoint:

```text
POST /rentals
```

Contoh request:

```bash
curl -X POST "http://127.0.0.1:8000/rentals" \
-H "Content-Type: application/json" \
-d "{\"rental_id\":101,\"customer_id\":1,\"inventory_id\":1,\"amount\":4.99}"
```

Jika berhasil, API mengembalikan HTTP `201 Created`.

Contoh response:

```json
{
    "message": "Rental berhasil dibuat",
    "rental_id": 101
}
```

## Q23 - Validasi Amount Negatif

Contoh request:

```bash
curl -X POST "http://127.0.0.1:8000/rentals" \
-H "Content-Type: application/json" \
-d "{\"rental_id\":102,\"customer_id\":1,\"inventory_id\":1,\"amount\":-4.99}"
```

Nilai `amount` harus lebih besar dari 0. Request dengan nilai negatif akan ditolak oleh validasi Pydantic dengan HTTP `422 Unprocessable Entity`.

## Q24 - Inventory Tidak Tersedia

Contoh request:

```bash
curl -X POST "http://127.0.0.1:8000/rentals" \
-H "Content-Type: application/json" \
-d "{\"rental_id\":103,\"customer_id\":1,\"inventory_id\":999999,\"amount\":4.99}"
```

Jika inventory tidak tersedia, API mengembalikan HTTP `409 Conflict`.

Contoh response:

```json
{
    "detail": "Inventory tidak tersedia"
}
```

## Laporan

Hasil pengujian, output SQL, error, perbandingan ORM dengan Raw SQL, serta pembahasan Q1-Q24 didokumentasikan pada file `laporan.md`.