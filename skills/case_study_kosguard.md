# CASE STUDY: KOSGUARD — Melindungi Barang Pribadi di Ruang Bersama Kost

## Quick Facts
* **Produk:** KOSGUARD (Aplikasi Mobile Android/iOS & Dashboard Pemilik Kost)
* **Tagline:** *Know the Owner. Track the Incident. Protect Shared Spaces.*
* **Target Pengguna:** Penghuni kost & Pemilik/Pengelola properti
* **Tech Stack Utama:** Flutter, Laravel REST API, MySQL, Firebase Cloud Messaging (FCM)
* **Status:** MVP Planning & Architecture Design

---

## Overview
KOSGUARD adalah sistem pencatatan kepemilikan barang dan manajemen insiden berbasis aplikasi mobile untuk lingkungan rumah kost. Proyek ini dirancang untuk mengatasi gesekan sosial dan hilangnya jejak kepemilikan barang di fasilitas bersama—khususnya area jemuran dan kulkas bersama—tanpa mengorbankan privasi penghuni atau mengandalkan pengawasan invasif.

---

## The Problem
Di rumah kost dengan fasilitas komunal, dua titik utama sering memicu masalah koordinasi dan konflik antarpenghuni:
1. **Area Jemuran Bersama:** Pakaian sering dipindahkan demi mengamankan tempat, tertukar secara tidak sengaja, atau hilang tanpa jejak.
2. **Kulkas Bersama (*Shared Chiller*):** Makanan atau bahan masakan milik penghuni sering terambil atau dibuang tanpa izin, meskipun sudah diberi label nama manual.

Selama ini, koordinasi hanya mengandalkan grup WhatsApp. Pesan mudah tenggelam, alur tanggung jawab tidak jelas, dan pemilik kost kesulitan melacak status penyelesaian masalah.

**Batasan & Prinsip Utama (Constraints):**
* Tidak menggunakan integrasi CCTV atau deteksi pencurian otomatis yang menuduh penghuni tanpa bukti.
* Tidak mewajibkan penempelan stiker QR fisik pada setiap helai pakaian atau kotak makanan.
* Detail kontak pribadi pemilik barang tidak boleh terekspos ke publik di dalam inventaris bersama.

---

## Process & Key Decisions
Dalam merancang arsitektur produk dan alur pengguna, fokus utama diarahkan pada keseimbangan antara **transparansi operasional**, **privasi data**, dan **kemudahan penggunaan harian**:

* **Identitas Permanen vs. Sesi Penggunaan (*Session-Based*):** Setiap barang fisik didaftarkan sekali sebagai catatan permanen dengan foto dan kategori (`items`). Saat diletakkan di fasilitas bersama, penghuni cukup mengaktifkan sesi penggunaan (`item_usage`) agar tidak perlu menginput ulang data barang yang sama.
* **Satu QR Permanen per Kamar:** Daripada mencetak QR untuk tiap barang, setiap kamar memiliki satu token QR acak sebagai pintu masuk cepat untuk melihat konteks inventaris kamar yang relevan (dengan validasi hak akses di *backend*).
* **Kebijakan Kedaluwarsa Otomatis:** Untuk mencegah barang menumpuk tanpa batas waktu di fasilitas bersama, sistem menetapkan masa aktif otomatis berdasarkan kebijakan fasilitas (48 jam untuk jemuran, 7 hari untuk bahan mentah di kulkas, dan 10 hari untuk makanan instan/matang). Status `EXPIRED` murni berfungsi sebagai aturan tata kelola fasilitas, bukan vonis barang hilang atau makanan basi.
* **Pencatatan Log Tanpa Beban Manual:** Semua perubahan status penting dicatat secara otomatis oleh sistem beserta aktor dan stempel waktu (*timestamp*).

---

## Solution
KOSGUARD membagi pengalaman pengguna ke dalam dua ekosistem terintegrasi: aplikasi mobile untuk penghuni dan dashboard operasional untuk pemilik kost.

### 1. Inventaris Bersama yang Menjaga Privasi
Penghuni dapat melihat daftar barang yang sedang aktif di area jemuran maupun kulkas beserta foto, kategori, dan nomor kamar pemiliknya. Informasi kontak pribadi disembunyikan untuk mencegah interaksi yang tidak diinginkan di luar sistem.

### 2. Pelaporan Insiden & Klaim Kepemilikan Privat
Ketika terjadi masalah, penghuni dapat melaporkannya langsung melalui aplikasi dengan tiga kategori netral: **Hilang (*Missing*)**, **Tertukar/Salah Tempat (*Swapped*)**, atau **Barang Temuan (*Found*)**. Untuk barang temuan atau sengketa, penghuni yang merasa memiliki barang dapat mengajukan **Klaim Kepemilikan** dengan menyertakan ciri khusus rahasia yang hanya bisa diverifikasi oleh pemilik kost.

### 3. Dashboard Pemilik Kost & Notifikasi Real-Time
Pemilik atau pengelola properti mendapatkan ringkasan langsung mengenai jumlah sesi aktif, sesi kedaluwarsa, laporan insiden terbuka (`OPEN` / `UNDER_REVIEW`), hingga klaim yang menunggu verifikasi. Integrasi dengan *Laravel Scheduler* dan *Firebase Cloud Messaging* memastikan notifikasi dikirim tepat waktu saat sesi berakhir atau muncul laporan baru.

---

## Target Success Metrics (MVP Validation)
Karena produk berada pada tahap perencanaan implementasi (*MVP draft*), keberhasilan uji coba awal (*pilot testing*) akan diukur melalui indikator berikut:

| Area Evaluasi | Metrik Utama yang Diukur |
| :--- | :--- |
| **Kemudahan Adopsi** | Persentase penyelesaian registrasi barang & median waktu input (target: hanya butuh foto & kategori). |
| **Kebersihan Data** | Persentase sesi aktif yang diperbarui tepat waktu (diambil kembali atau otomatis kedaluwarsa). |
| **Akuntabilitas Insiden** | Persentase laporan hilang/tertukar/temuan yang ditindaklanjuti dan diselesaikan oleh pengelola. |
| **Keamanan Privasi** | Nol kebocoran data kontak pribadi penghuni maupun detail klaim rahasia selama pengujian. |

---

## Learnings & Scope Discipline
Merancang sistem untuk lingkungan tempat tinggal bersama mengajarkan bahwa **teknologi tidak selalu harus menggantikan penilaian manusia**. Keputusan paling krusial dalam PRD ini adalah menjaga batas ruang lingkup (*Non-Goals*): menghindari fitur pengawasan ekstrem seperti CCTV atau pelabelan "pencurian" otomatis, dan memilih fokus pada **jejak audit yang objektif serta alur mediasi yang adil**.

---

## Visual Asset Checklist (Untuk Halaman Portfolio)
Agar *case study* ini semakin menarik secara visual saat dipublikasikan, kamu bisa melengkapinya dengan aset berikut:
1. **Hero Mockup:** Tampilan layar *Shared Inventory* dan *My Items* pada aplikasi Flutter.
2. **System Diagram:** Alur siklus hidup status barang (`REGISTERED` $\rightarrow$ `ACTIVE` $\rightarrow$ `EXPIRED` / `RETRIEVED` / `INCIDENT`).
3. **Privacy & Claim Flow:** Perbandingan tampilan publik vs. tampilan verifikasi klaim rahasia di *Dashboard* pemilik kost.