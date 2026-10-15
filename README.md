# Portal Pembelajaran Fisika Kelas X - SMAN 1 HALTIM

Portal pembelajaran fisika digital terpadu untuk siswa Kelas X (X-1 s/d X-5) di SMA Negeri 1 Halmahera Timur (SMAN 1 HALTIM), diampu oleh **Pak Dul**.

Desain website ini mengadopsi estetika hangat, bersih, dan minimalis yang terinspirasi dari antarmuka modern *Nudge* (warm neutral oat/sand palette, floating pill navigation, dan tipografi elegan).

---

## 🌟 Fitur Utama

### 1. Halaman Publik Siswa (`index.html`)
- **Hero & Sambutan Guru:** Profil pengampu dengan kutipan motivasi belajar fisika.
- **Modul & Materi Pembelajaran:** Silabus fisika semester ganjil/genap (Pengukuran Presisi, Analisis Vektor, Kinematika GLB/GLBB, Dinamika Gerak Newton, dan Energi Terbarukan) dengan tautan langsung ke modul/Google Drive/YouTube.
- **Papan Pengumuman Interaktif:** Info jadwal praktikum, ulangan harian, dan remedial.
- **Rekap Presensi & Nilai Siswa:** Tabel transparansi nilai (Hadir, Izin, Sakit, Alfa, Tugas, UH, UTS, UAS) dengan filter per kelas (X-1 s/d X-5) dan fitur pencarian nama/NISN secara instan.
- **Desain Responsif:** Tampilan desktop berupa tabel data elegan, dan tampilan ponsel secara otomatis beradaptasi menjadi kartu (cards) yang rapi.

### 2. Portal Guru & Admin Dashboard (`admin.html`)
- **Login Keamanan:** Terintegrasi penuh dengan Supabase Authentication (hanya guru terotorisasi yang dapat mengelola data).
- **Manajemen Nilai & Presensi (CRUD):** Tambah, ubah, dan hapus data siswa serta rekap kehadiran dan nilai.
- **Manajemen Materi Pembelajaran:** Unggah modul/dokumen langsung ke Supabase Storage (`modul-fisika`) atau tautkan link video/drive.
- **Manajemen Pengumuman:** Publikasikan pengumuman baru dengan penanda prioritas penting.
- **Export Data:** Unduh rekap lengkap kehadiran dan nilai siswa dalam format CSV/Excel.

---

## 🛠️ Teknologi yang Digunakan

- **Frontend:** Pure HTML5, Modern Vanilla JavaScript (ES6+)
- **Styling:** [Tailwind CSS](https://tailwindcss.com/) (CDN)
- **Icons:** [Lucide Icons](https://lucide.dev/) (CDN)
- **Backend & Database:** [Supabase](https://supabase.com/) (PostgreSQL Database, Supabase Auth, & Supabase Storage)

*Tanpa build step (`no node_modules`), ringan, dan langsung bisa dijalankan di browser maupun di-deploy ke Vercel, Netlify, atau GitHub Pages.*

---

## 🚀 Setup & Konfigurasi Supabase

1. Buat project baru di [Supabase Dashboard](https://supabase.com).
2. Masuk ke menu **SQL Editor**, buka file `setup_and_seed.sql`, salin seluruh isinya, dan klik **Run**. Script ini akan:
   - Membuat tabel `students`, `attendance`, `grades`, `materials`, dan `announcements`.
   - Mengatur Row Level Security (RLS) yang aman.
   - Membuat bucket penyimpanan `modul-fisika` untuk upload file materi.
   - Mengisi data awal (seed data) siswa dan materi.
3. Buat akun guru di menu **Authentication > Users** (Add User > Create User).
4. Pastikan URL dan Anon Key di `index.html` dan `admin.html` sudah sesuai dengan project Supabase Anda.

---

## 📄 Lisensi

Hak Cipta &copy; 2026 SMAN 1 Halmahera Timur (SMAN 1 HALTIM) & Tim Fisika.
