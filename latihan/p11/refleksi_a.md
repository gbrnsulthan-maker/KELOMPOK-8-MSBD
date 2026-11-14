# Reflektif A: Peran dan Hak Akses

Dalam pengelolaan database PostgreSQL, kepemilikan objek menentukan siapa yang memiliki kendali atas tabel. Pemilik tabel dapat melakukan operasi seperti ALTER dan DROP. Sementara itu, pengguna lain hanya dapat menjalankan operasi sesuai hak akses yang diberikan melalui GRANT.

Melalui latihan ini, kami memahami bahwa pemberian hak akses perlu disesuaikan dengan tanggung jawab setiap pengguna. Penggunaan ALTER DEFAULT PRIVILEGES membantu pemilik objek memberikan hak akses otomatis kepada pengguna tertentu pada tabel baru.

kami juga mempelajari fungsi WITH GRANT OPTION yang memungkinkan pengguna meneruskan hak akses kepada pengguna lain. Namun, ketika pemilik mencabut hak tersebut menggunakan REVOKE CASCADE, hak akses yang diteruskan ikut dicabut.

Menurut kami, pengaturan hak akses perlu dilakukan secara terstruktur agar setiap pengguna hanya memperoleh akses sesuai kebutuhannya. Hal ini membantu menjaga keamanan dan mencegah perubahan database oleh pihak yang tidak memiliki kewenangan.