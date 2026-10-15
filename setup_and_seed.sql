-- ====================================================================
-- SOLUSI LENGKAP SUPABASE: FIX RLS PERMISSION, SEED DATA & STORAGE
-- SMAN 1 HALTIM - KELAS X FISIKA
-- ====================================================================

-- 1. PASTIKAN SEMUA TABEL ADA DENGAN STRUKTUR LENGKAP
CREATE TABLE IF NOT EXISTS public.students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nisn VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    class_name VARCHAR(10) NOT NULL CHECK (class_name IN ('X-1', 'X-2', 'X-3', 'X-4', 'X-5')),
    gender VARCHAR(1),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tambahkan kolom gender jika tabel students sudah terlanjur dibuat tanpa gender
ALTER TABLE public.students ADD COLUMN IF NOT EXISTS gender VARCHAR(1);

CREATE TABLE IF NOT EXISTS public.attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Hadir', 'Izin', 'Sakit', 'Alfa')),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_student_attendance_per_date UNIQUE (student_id, date)
);

CREATE TABLE IF NOT EXISTS public.grades (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
    category VARCHAR(10) NOT NULL CHECK (category IN ('Tugas', 'UH', 'UTS', 'UAS')),
    score NUMERIC(5,2) NOT NULL CHECK (score >= 0 AND score <= 100),
    title VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.materials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_important BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ====================================================================
-- 2. RESET & PERBAIKI ROW LEVEL SECURITY (RLS)
-- Mengizinkan operasi SELECT, INSERT, UPDATE, DELETE untuk publik & admin
-- Menghilangkan error 42501 (new row violates row-level security policy)
-- ====================================================================

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

-- Drop policy lama jika ada
DROP POLICY IF EXISTS "Publik dapat membaca data siswa" ON public.students;
DROP POLICY IF EXISTS "Hanya guru authenticated yang dapat mengelola siswa" ON public.students;
DROP POLICY IF EXISTS "Akses penuh siswa" ON public.students;
CREATE POLICY "Akses penuh siswa" ON public.students FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Publik dapat membaca absensi" ON public.attendance;
DROP POLICY IF EXISTS "Hanya guru authenticated yang dapat mengelola absensi" ON public.attendance;
DROP POLICY IF EXISTS "Akses penuh absensi" ON public.attendance;
CREATE POLICY "Akses penuh absensi" ON public.attendance FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Publik dapat membaca nilai" ON public.grades;
DROP POLICY IF EXISTS "Hanya guru authenticated yang dapat mengelola nilai" ON public.grades;
DROP POLICY IF EXISTS "Akses penuh nilai" ON public.grades;
CREATE POLICY "Akses penuh nilai" ON public.grades FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Publik dapat membaca materi" ON public.materials;
DROP POLICY IF EXISTS "Hanya guru authenticated yang dapat mengelola materi" ON public.materials;
DROP POLICY IF EXISTS "Akses penuh materi" ON public.materials;
CREATE POLICY "Akses penuh materi" ON public.materials FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Publik dapat membaca pengumuman" ON public.announcements;
DROP POLICY IF EXISTS "Hanya guru authenticated yang dapat mengelola pengumuman" ON public.announcements;
DROP POLICY IF EXISTS "Akses penuh pengumuman" ON public.announcements;
CREATE POLICY "Akses penuh pengumuman" ON public.announcements FOR ALL USING (true) WITH CHECK (true);

-- ====================================================================
-- 3. BUCKET STORAGE UNTUK FILE MODUL PEMBELAJARAN
-- ====================================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('modul-fisika', 'modul-fisika', true)
ON CONFLICT (id) DO UPDATE SET public = true;

DROP POLICY IF EXISTS "Publik dapat melihat modul" ON storage.objects;
CREATE POLICY "Publik dapat melihat modul" ON storage.objects
FOR SELECT USING (bucket_id = 'modul-fisika');

DROP POLICY IF EXISTS "Admin dapat mengunggah modul" ON storage.objects;
CREATE POLICY "Admin dapat mengunggah modul" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'modul-fisika');

DROP POLICY IF EXISTS "Admin dapat memperbarui modul" ON storage.objects;
CREATE POLICY "Admin dapat memperbarui modul" ON storage.objects
FOR UPDATE USING (bucket_id = 'modul-fisika');

DROP POLICY IF EXISTS "Admin dapat menghapus modul" ON storage.objects;
CREATE POLICY "Admin dapat menghapus modul" ON storage.objects
FOR DELETE USING (bucket_id = 'modul-fisika');

-- ====================================================================
-- 4. SEED DATA AWAL (SISWA, MATERI, PENGUMUMAN)
-- ====================================================================

-- Data Siswa Kelas X (X-1 s/d X-5) - Tanpa kolom gender agar kompatibel 100%
INSERT INTO public.students (nisn, name, class_name) VALUES
('0089123401', 'Ahmad Fathanah Sangaji', 'X-1'),
('0089123402', 'Nurul Aulia Maba', 'X-1'),
('0089123403', 'Rivaldo Boki', 'X-1'),
('0089123404', 'Siti Rahmawati Wasile', 'X-2'),
('0089123405', 'Dimas Tri Tobelo', 'X-2'),
('0089123406', 'Fahrul Subaim', 'X-3'),
('0089123407', 'Dewi Lestari Buli', 'X-4'),
('0089123408', 'Zulkifli Kota Maba', 'X-5')
ON CONFLICT (nisn) DO UPDATE 
SET name = EXCLUDED.name, class_name = EXCLUDED.class_name;

-- Data Materi Fisika
INSERT INTO public.materials (title, description, file_url) VALUES
('Hakikat Fisika, Metode Ilmiah, & Pengukuran Presisi', 'Panduan membaca skala jangka sorong, mikrometer sekrup, angka penting, dan ketidakpastian eksperimental.', 'https://drive.google.com'),
('Analisis Vektor Dua Dimensi & Koordinat Kartesius', 'Menghitung resultan vektor menggunakan metode poligon, jajar genjang, dan penguraian komponen sumbu X-Y.', 'https://drive.google.com'),
('Kinematika Gerak Lurus Beraturan (GLB & GLBB)', 'Analisis perpindahan, kecepatan rata-rata, percepatan konstan, dan gerak vertikal jatuh bebas disertai grafik v-t.', 'https://youtube.com'),
('Dinamika Gerak: Hukum-Hukum Newton', 'Penerapan Hukum I, II, dan III Newton pada bidang miring, bidang datar licin/kasar, serta sistem tegangan tali katrol.', 'https://youtube.com'),
('Usaha, Energi Mekanik, & Energi Terbarukan di HALTIM', 'Kajian teorema usaha-energi kinetik serta eksplorasi potensi pemanfaatan energi surya dan angin di Maluku Utara.', 'https://drive.google.com')
ON CONFLICT DO NOTHING;

-- Data Pengumuman Guru (Pak Dul)
INSERT INTO public.announcements (title, content, is_important) VALUES
('Penilaian Harian (UH) 1: Pengukuran Presisi & Analisis Vektor', 'Diberitahukan kepada seluruh siswa Kelas X (X-1 s/d X-5) bahwa UH 1 akan dilaksanakan di Lab Fisika. Harap membawa jangka sorong pribadi dan kalkulator ilmiah.', true),
('Batas Akhir Pengumpulan Laporan Praktikum Jangka Sorong', 'Laporan fisik praktikum pengukuran presisi dikumpulkan paling lambat hari Jumat pukul 14.00 WIT di meja Pak Dul.', false),
('Jadwal Bimbingan Pengayaan & Remedial Fisika Semester Ganjil', 'Siswa yang ingin berkonsultasi mengenai materi vektor dan kinematika gerak dipersilakan hadir di Lab Fisika setiap hari Rabu setelah jam pelajaran selesai.', false)
ON CONFLICT DO NOTHING;

-- 5. RELOAD SCHEMA POSTGREST CACHE
NOTIFY pgrst, 'reload schema';
