import psycopg

with psycopg.connect(
    "host=msbd-pg port=5432 dbname=latihan user=msbd password=msbd2026"
) as conn:
    conn.execute("CALL lab5.process_rental_commit(4, 1, 1, 4.99)")
    print("CALL berhasil")
