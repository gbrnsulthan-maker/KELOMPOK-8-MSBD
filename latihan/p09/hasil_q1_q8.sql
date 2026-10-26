
-- =====================================================
-- P09 - HASIL Q1-Q8
-- Nama: Novri Ilyasah
-- Materi: Transaksi dan Isolation Level PostgreSQL
-- Catatan: Query transaksi dua sesi dijalankan terpisah.
-- =====================================================

-- Q1: Kondisi awal rekening dan total saldo
SELECT id, nama, saldo
FROM p09.rekening
ORDER BY id;

SELECT COUNT(*) AS jumlah_rekening,
       SUM(saldo) AS total_saldo
FROM p09.rekening;


-- Q2: BEGIN dan visibilitas perubahan antarsesi
-- SESI 1
BEGIN;
UPDATE p09.rekening
SET saldo = saldo - 100000
WHERE id = 1;
SELECT id, nama, saldo
FROM p09.rekening
WHERE id = 1;
-- Periksa dari sesi 2 sebelum COMMIT.
COMMIT;


-- Q3: Membandingkan COMMIT dan ROLLBACK
-- Uji COMMIT
BEGIN;
UPDATE p09.rekening
SET saldo = saldo + 50000
WHERE id = 1;
SELECT id, nama, saldo FROM p09.rekening WHERE id = 1;
COMMIT;

-- Uji ROLLBACK
BEGIN;
UPDATE p09.rekening
SET saldo = saldo + 100000
WHERE id = 1;
SELECT id, nama, saldo FROM p09.rekening WHERE id = 1;
ROLLBACK;
SELECT id, nama, saldo FROM p09.rekening WHERE id = 1;


-- Q4: SAVEPOINT dan ROLLBACK TO SAVEPOINT
BEGIN;
UPDATE p09.rekening
SET saldo = saldo + 100000
WHERE id = 1;

SAVEPOINT sebelum_perubahan_kedua;

UPDATE p09.rekening
SET saldo = saldo + 50000
WHERE id = 1;

SELECT id, nama, saldo FROM p09.rekening WHERE id = 1;

ROLLBACK TO SAVEPOINT sebelum_perubahan_kedua;

SELECT id, nama, saldo FROM p09.rekening WHERE id = 1;
COMMIT;


-- Q5: Atomicity, consistency, dan CHECK constraint
-- Uji berikut sengaja melanggar CHECK.
-- Jalankan secara terpisah; jangan jalankan bersama seluruh file.
-- UPDATE p09.rekening SET saldo = -100 WHERE id = 1;


-- Q6: Non-repeatable read pada READ COMMITTED
-- SESI 1
BEGIN ISOLATION LEVEL READ COMMITTED;

SELECT id, nama, saldo
FROM p09.rekening
WHERE id = 1;

-- Di sesi 2, ubah saldo dan COMMIT.
-- Kemudian ulangi SELECT di sesi 1.
SELECT id, nama, saldo
FROM p09.rekening
WHERE id = 1;

COMMIT;


-- Q7: REPEATABLE READ
-- SESI 1
BEGIN ISOLATION LEVEL REPEATABLE READ;

SELECT id, nama, saldo
FROM p09.rekening
WHERE id = 1;

-- Di sesi 2, ubah saldo dan COMMIT.
-- Ulangi SELECT di sesi 1; hasil tetap dari snapshot transaksi.
SELECT id, nama, saldo
FROM p09.rekening
WHERE id = 1;

COMMIT;


-- Q8: Phantom read pada dua isolation level
-- READ COMMITTED: jalankan di sesi 1
BEGIN ISOLATION LEVEL READ COMMITTED;

SELECT id, nama, saldo
FROM p09.rekening
WHERE saldo >= 1000000
ORDER BY id;

-- Di sesi 2, tambahkan rekening yang memenuhi kondisi.
-- INSERT INTO p09.rekening (id, nama, saldo)
-- VALUES (4, 'Dina', 2000000);

SELECT id, nama, saldo
FROM p09.rekening
WHERE saldo >= 1000000
ORDER BY id;

COMMIT;


-- REPEATABLE READ: jalankan di sesi 1
BEGIN ISOLATION LEVEL REPEATABLE READ;

SELECT id, nama, saldo
FROM p09.rekening
WHERE saldo >= 1000000
ORDER BY id;

-- Di sesi 2, tambahkan rekening baru, lalu ulangi SELECT di sesi 1.
-- INSERT INTO p09.rekening (id, nama, saldo)
-- VALUES (5, 'Eka', 1800000);

SELECT id, nama, saldo
FROM p09.rekening
WHERE saldo >= 1000000
ORDER BY id;

COMMIT;
