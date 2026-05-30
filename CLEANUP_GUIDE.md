# Panduan Cleanup Repo hend_kasir

> Jalankan semua perintah dari root folder project (`hend_kasir/`)

---

## Step 1 — Hapus File Sampah dari Git Tracking

Jalankan satu per satu atau sekaligus:

```bash
# 1. Data toko nyata — PRIORITAS UTAMA
git rm --cached rokok_virgo_supabase.json

# 2. Build artifact
git rm --cached build_log.txt

# 3. Mockup UI (simpan dulu lokal kalau masih dibutuhkan)
git rm --cached home_v2.html

# 4. Script sementara
git rm --cached import_json.dart

# 5. SQL files di root
git rm --cached migrasi.sql
git rm --cached rls_fix.sql
git rm --cached supabase_setup.sql
git rm --cached supabase_setup_v2.sql

# 6. Dokumentasi desain (boleh dipindah, bukan dihapus)
git rm --cached theme.md
```

Atau sekaligus dalam satu baris:
```bash
git rm --cached \
  rokok_virgo_supabase.json \
  build_log.txt \
  home_v2.html \
  import_json.dart \
  migrasi.sql \
  rls_fix.sql \
  supabase_setup.sql \
  supabase_setup_v2.sql \
  theme.md
```

---

## Step 2 — Buat Struktur Folder yang Rapi

```bash
# Folder untuk SQL / Supabase
mkdir -p supabase/migrations

# Folder untuk dokumentasi
mkdir -p docs/mockups
mkdir -p tools
```

---

## Step 3 — Pindahkan File yang Masih Dibutuhkan

```bash
# SQL files → supabase/
mv migrasi.sql supabase/migrations/001_initial.sql
mv rls_fix.sql supabase/migrations/002_rls_fix.sql
mv supabase_setup.sql supabase/setup_v1.sql
mv supabase_setup_v2.sql supabase/setup_v2.sql

# Mockup UI → docs/
mv home_v2.html docs/mockups/home_v2.html

# Dokumentasi tema → docs/
mv theme.md docs/theme.md

# Script import → tools/ (kalau masih relevan)
mv import_json.dart tools/import_json.dart
```

File yang benar-benar dihapus (tidak perlu disimpan):
```bash
rm -f build_log.txt
rm -f rokok_virgo_supabase.json
```

---

## Step 4 — Update `.gitignore`

Tambahkan baris berikut ke `.gitignore`:

```gitignore
# Build artifacts
build_log.txt
*.log

# Sensitive data / store data
*_supabase.json
*.data.json

# Script sementara di root
import_json.dart
test_db.dart
test_item.dart

# Design mockups (sudah di docs/, tidak perlu di root)
*.html

# Markdown drafts di root (kecuali README dan AGENTS)
# theme.md   ← sudah dipindah ke docs/
```

Atau jalankan ini langsung:
```bash
cat >> .gitignore << 'EOF'

# ===== Tambahan cleanup =====
# Build artifacts
build_log.txt
*.log

# Sensitive store data
*_supabase.json

# HTML mockups di root
home_v2.html

# Script sementara
import_json.dart
EOF
```

---

## Step 5 — Commit Semua Perubahan

```bash
# Stage semua perubahan
git add .

# Commit
git commit -m "chore: cleanup root - remove sensitive data, reorganize sql & docs

- Remove rokok_virgo_supabase.json (sensitive store data)
- Remove build_log.txt (build artifact)
- Move SQL files to supabase/migrations/
- Move home_v2.html to docs/mockups/
- Move theme.md to docs/
- Update .gitignore to prevent future leaks"

# Push
git push origin main
```

---

## Step 6 (Opsional) — Hapus dari Git History

File `rokok_virgo_supabase.json` masih ada di git history meski sudah di-remove. Kalau mau benar-benar hilang:

```bash
# Install git-filter-repo dulu (lebih aman dari filter-branch)
pip install git-filter-repo

# Hapus file dari seluruh history
git filter-repo --path rokok_virgo_supabase.json --invert-paths

# Force push (HATI-HATI: ini rewrite history)
git push origin main --force
```

> ⚠️ **Peringatan:** Force push akan mengubah commit SHA seluruh history. Kalau ada orang lain yang clone repo ini, mereka perlu re-clone. Untuk solo project ini aman dilakukan.

---

## Struktur Akhir Root Repo

Setelah cleanup, root repo harusnya terlihat seperti ini:

```
hend_kasir/
├── .github/
│   └── workflows/
├── .vscode/
├── android/
├── docs/
│   ├── mockups/
│   │   └── home_v2.html
│   └── theme.md
├── ios/
├── lib/
├── linux/
├── macos/
├── supabase/
│   ├── migrations/
│   │   ├── 001_initial.sql
│   │   └── 002_rls_fix.sql
│   ├── setup_v1.sql
│   └── setup_v2.sql
├── test/
├── tools/
│   └── import_json.dart
├── web/
├── windows/
├── .gitattributes
├── .gitignore          ← updated
├── .metadata
├── AGENTS.md
├── IMPROVEMENT_ROADMAP.md  ← file baru ini
├── README.md
├── analysis_options.yaml
├── pubspec.lock
└── pubspec.yaml
```

---

## Verifikasi

Setelah selesai, pastikan tidak ada file sensitif yang masih ter-track:

```bash
# Cek apakah masih ada file json yang tidak seharusnya
git ls-files | grep "\.json"

# Cek status git bersih
git status

# Pastikan gitignore berjalan
echo "test_data.json" > test_data.json
git status  # harusnya tidak muncul jika pattern sudah di .gitignore
rm test_data.json
```

---

*Cleanup guide untuk `devtya/hend_kasir` — v1.4.10+24*
