\# Laporan Praktikum P01

\## Docker dan Docker Compose



Nama: Novri Ilyasah

Repository: https://github.com/gbrnsulthan-maker/KELOMPOK-8-MSBD



\## Langkah 1. Memasang dan Memverifikasi Docker



\### 1. Docker Version



Perintah:



docker --version



Output:



Docker version 29.7.2, build a7dcaa6





\### 2. Docker Compose Version



Perintah:



docker compose version



Output:



Docker Compose version v5.4.0





\### 3. Docker Hello World



Perintah:



docker run --rm hello-world



Hasil:



Perintah berhasil dijalankan dan menampilkan pesan "Hello from Docker!". Hal ini menunjukkan bahwa Docker Engine sudah berjalan dan dapat menjalankan container.





\### 4. Docker Image



Docker Image adalah template yang berisi file, program, library, dan konfigurasi yang dibutuhkan untuk menjalankan sebuah aplikasi. Container dibuat berdasarkan Docker Image. Contohnya, PostgreSQL 17 dijalankan menggunakan image postgres:17.





\### 5. Container



Container adalah instance yang berjalan dari sebuah Docker Image. Container menyediakan lingkungan terisolasi untuk menjalankan aplikasi beserta dependensinya. Pada latihan ini terdapat container PostgreSQL, MongoDB, dan Redis.





\### 6. Volume



Volume adalah media penyimpanan yang dikelola Docker untuk menyimpan data container secara persisten. Dengan volume, data PostgreSQL dan MongoDB tetap dapat disimpan ketika container dihentikan atau dibuat ulang.





\## Langkah 2. Menyusun dan Menjalankan Docker Compose



\### 1. Docker Compose PS



Perintah:



docker compose ps



Hasil:



msbd-mongo   mongo:8          Up

msbd-pg      postgres:17     Up (healthy)

msbd-redis   redis:7-alpine   Up



Ketiga layanan berhasil berjalan. PostgreSQL menunjukkan status healthy sehingga database siap digunakan.





\### 2. Docker Compose Logs PostgreSQL



Perintah:



docker compose logs postgres | Select-Object -Last 20



Hasil menunjukkan PostgreSQL berhasil melakukan startup dan menampilkan:



"database system is ready to accept connections"



PostgreSQL juga berjalan pada port 5432.





\## Pertanyaan Wajib Langkah 2



\### 1. Apa yang terjadi jika volume PostgreSQL dihapus kemudian menjalankan docker compose down -v?



Volume PostgreSQL digunakan untuk menyimpan data database secara persisten. Jika volume PostgreSQL dihapus dan kemudian docker compose down -v dijalankan, volume yang dibuat oleh Docker Compose akan ikut dihapus. Data PostgreSQL yang tersimpan di dalam volume tersebut juga akan hilang. Ketika docker compose up -d dijalankan kembali, PostgreSQL akan membuat database dan data baru berdasarkan konfigurasi pada docker-compose.yml.





\### 2. Mengapa menggunakan "5432:5432"?



Format "5432:5432" berarti port 5432 pada komputer host diarahkan ke port 5432 di dalam container PostgreSQL. Port pertama adalah port host, sedangkan port kedua adalah port yang digunakan PostgreSQL di dalam container.



Jika port 5432 pada komputer sudah digunakan oleh PostgreSQL lain, port host harus diubah. Contohnya:



"5433:5432"



Dengan konfigurasi tersebut, PostgreSQL tetap menggunakan port 5432 di dalam container, tetapi dapat diakses melalui port 5433 dari komputer host.





\### 3. Apa fungsi healthcheck?



Healthcheck digunakan untuk memeriksa apakah sebuah container sudah siap digunakan. Pada PostgreSQL, healthcheck menjalankan pg\_isready untuk memeriksa kesiapan database menerima koneksi.



Healthcheck penting ketika layanan lain bergantung pada database karena status container yang sudah berjalan belum tentu berarti database sudah siap menerima koneksi. Healthcheck membantu memastikan kondisi layanan sebelum digunakan oleh layanan lain.





\### 4. Mengapa password tidak sebaiknya ditulis langsung di docker-compose.yml?



Password yang ditulis langsung di docker-compose.yml dapat terlihat oleh orang lain dan ikut masuk ke repositori Git. Hal tersebut dapat menyebabkan kredensial tersebar dan dapat digunakan oleh pihak yang tidak memiliki izin.



Salah satu cara yang lebih aman adalah menggunakan environment file seperti .env dan memasukkan .env ke dalam .gitignore. Dengan cara tersebut, nilai password tidak perlu dimasukkan ke repositori Git.

