# Q29 — Strategi Retry Transaksi

```text
max_attempts = 5

for attempt in 1..max_attempts:
    begin transaction
    try:
        jalankan seluruh operasi transaksi
        commit
        return sukses
    catch error:
        rollback
        jika SQLSTATE bukan 40001 dan bukan 40P01:
            lempar kembali error
        jika attempt == max_attempts:
            lempar kembali error
        delay = min(base_delay * 2^(attempt - 1), max_delay)
        tunggu delay + random_jitter
```

Retry harus mengulang transaksi secara utuh. Batasi percobaan, gunakan exponential backoff dengan jitter, dan pastikan pengulangan tidak menggandakan efek samping.
