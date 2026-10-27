# Q11 — Ringkasan Anomali, Hasil Eksperimen, dan Mitigasi

| Anomali | Hasil di eksperimen kami | Bukti | Mitigasi |
|---|---|---|---|
| **Dirty read** | TIDAK terjadi. Sesi dengan READ UNCOMMITTED tetap membaca saldo lama (1000.00) walau transaksi lain memegang update belum commit. | `bukti/q09_dirty_read.png` | PostgreSQL memperlakukan READ UNCOMMITTED sebagai READ COMMITTED. |
| **Lost update** | TERJADI. Dua sesi membaca 1.000.000, lalu menulis 900 dan 800. Hasil akhir 800 — update pertama hilang. | `bukti/q10_lost_update.png` | Atomic update (Q12), `SELECT ... FOR UPDATE` (Q13), atau optimistic concurrency (Q14). |
| **Non-repeatable read** | TERJADI pada READ COMMITTED (baca ulang setelah transaksi lain commit memberi nilai beda). | `hasil_q1_q8.sql` (Q6 Novri) | Naikkan ke REPEATABLE READ. |
| **Phantom read** | TERJADI: jumlah baris hasil query WHERE berubah setelah transaksi lain INSERT. | `hasil_q1_q8.sql` (Q8 Novri) | Naikkan ke SERIALIZABLE. |

Kesimpulan: PostgreSQL menutup dirty read secara bawaan, tetapi lost update
tetap mungkin pada READ COMMITTED bila aplikasi membaca-lalu-menulis tanpa
mekanisme kunci atau kondisi versi — persis yang kami reproduksi di Q10 dan
perbaiki di Q12–Q14.
