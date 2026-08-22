# 📖 TUTORIAL LENGKAP CARA PENGGUNAAN

## A. Sebagai Pengguna Modul (di HP Android)

### Prasyarat
1. HP sudah **root**: Magisk / KernelSU / APatch / turunannya
2. **Zygist aktif** (di Magisk; di KSU pakai Zygist Next)
3. Install dulu 2 modul ini (urutan bebas):
   - [Play Integrity Fix [INJECT]](https://github.com/KOWX712/PlayIntegrityFix/releases/latest) **atau** [Play Integrity Fork](https://github.com/osm0sis/PlayIntegrityFork/releases/latest)
   - [Tricky Store](https://github.com/5ec1cff/TrickyStore/releases/latest)
4. Reboot setelah install keduanya

### Install Modul Ini
1. Download zip dari tab **Releases** repo Anda
2. Flash lewat manager root → reboot
3. Saat instalasi, modul otomatis mengunduh keybox dan menulisnya ke Tricky Store

### Tombol Action (inti dari semuanya)
Setelah reboot, buka manager root → cari modul **C-IntegrityGuard** → tekan tombol **Action** ▶️. Script berjalan otomatis:
```
bunuh proses Google → tulis target.txt → spoof security patch 
→ pasang boot hash → update keybox → refresh fingerprint PIF
→ "Meets Strong Integrity with C-IntegrityGuard✨✨"
```
4. Verifikasi: install app **SPIC / Play Integrity Checker** dari Play Store → cek → harus dapat **MEETS_STRONG_INTEGRITY**

### WebUI Manager (buka dari KernelSU/APatch → modul → WebUI)
- **Home**: info versi modul, Android, kernel, tipe root, status online, jam
- **Menu**: Force Stop Play Store, Set Up Keybox, Custom Keybox, Target.txt, Security Patch, dll.
- **Menu +**: fitur lanjutan — *Clear all detection traces* (hati-hati: script ini menghapus data banyak app & mematikan ADB!), HMA configs, Widevine L1, dll.
- **Settings**: bahasa (25 tersedia termasuk Indonesia), tema gelap/terang, preset warna

## B. Sebagai Maintainer (di PC)

### 🔄 Rilis Versi Baru
1. Edit `changelog.md` — baris pertama WAJIB format: `***✨ vX.Y.Z – Version Changes:***` (CI membaca versi dari sini)
2. Commit & push
3. GitHub → tab **Actions** → **Build Release Module** → Run workflow
4. Bot otomatis: sync versi ke `module.prop` & `update.json` → zip → buat Release → commit balik

### 🔑 Ganti Keybox (tugas rutin paling penting!)
Keybox bisa dibanned Google sewaktu-waktu. Gejala: integrity gagal padahal kemarin berhasil.
1. Dapat keybox baru (format XML Tricky Store)
2. Encode to base64:
   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes("keybox.xml")) | Set-Content key -NoNewline
   ```
3. Replace isi file `key` di repo → commit push → modul akan fetch yang terbaru
4. Atau tanpa update repo: users bisa pakai **Menu → Set Up Custom Keybox**

### 🧪 Test Build Tanpa Rilis
Actions → **Build Test Module** → Run → hasil jadi artifact (tidak masuk Releases).

### 🛠 Edit Kode
Edit → commit → push. Untuk rilis, ikuti langkah "Rilis Versi Baru".

---

## ⚠️ Catatan Penting
1. **User lama Yurikey** yang ganti ke modul Anda: installer otomatis menghapus modul lama (sudah saya siapkan blok migrasinya).
2. **Belum diperbaiki** (dari analisis awal): bug quoting di `service.sh`, `mkdir` liar di `pif.sh`, duplikasi kode keybox. Mau saya perbaikan sekalian?
3. Jangan jalankan workflow release sebelum Anda yakin semua sudah oke — begitu dirilis, version tag terkunci.