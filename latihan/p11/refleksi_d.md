# Reflektif D — Risiko yang Masih Terbuka

Enkripsi kolom tidak menghilangkan seluruh risiko. Pertama, data masih dapat dibaca oleh aplikasi atau proses yang memiliki kunci dekripsi. Kebocoran kunci, log aplikasi, backup, dan kredensial dapat membuka data. Kedua, metadata dan pola akses masih dapat mengungkap informasi walaupun isi kolom telah dienkripsi.

Masking juga bukan anonimisasi mutlak. Kombinasi atribut seperti kota dan tahun lahir dapat mempersempit identitas seseorang.

Risiko operasional utama adalah pengelolaan kunci. Kunci tidak boleh ditanam permanen dalam source code atau dibagikan kepada role analitik. Bukti yang perlu dilampirkan berasal dari eksekusi Q21–Q24: perbedaan ciphertext, dekripsi terbatas, hak akses view, dan perbandingan kombinasi atribut. Angka hasil harus berasal dari pengujian aktual.
