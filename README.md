# WebQA Automation Hub

Web dashboard internal untuk tim QA — jalankan script automation Playwright langsung dari browser tanpa perlu buka terminal.

## Overview

QA Automation Hub adalah aplikasi web yang memungkinkan tim QA untuk:
- Menjalankan script Playwright automation dari browser
- Melihat log real-time saat script berjalan
- Mengakses report HTML hasil eksekusi
- Upload script baru langsung dari browser
- Melihat riwayat semua build yang pernah dijalankan

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────────────┐
│  Next.js    │────▶│  Jenkins    │────▶│  Playwright Runner  │
│  (Frontend) │     │  (CI/CD)    │     │  (Docker Container)  │
│  Port 3000  │     │  Port 8080  │     │                     │
└─────────────┘     └─────────────┘     └─────────────────────┘
```

## Tech Stack

| Layer | Teknologi |
|-------|-----------|
| Frontend | Next.js 16 (App Router) + TailwindCSS v4 + Shadcn UI |
| CI/CD | Jenkins |
| Automation | Playwright |
| Container | Docker + Docker Compose |

## Prerequisites

- Docker Desktop installed
- Docker Compose plugin
- Node.js 20+ (untuk development lokal)

## Installation & Setup

### 1. Clone Repository

```bash
git clone https://github.com/faishaltsq/Web-QA-Automation.git
cd Web-QA-Automation
```

### 2. Setup Environment Variables

Salin `.env.example` ke `.env.local` di folder `frontend`:

```bash
cp frontend/.env.example frontend/.env.local
```

Atur variabel yang diperlukan:
```env
TARGET_APP_URL=https://your-app-staging.example.com/
AUTOMATION_DIR=/path/to/your/automation/scripts
```

### 3. Jalankan dengan Docker Compose

```bash
docker compose up -d
```

### 4. Akses Aplikasi

| Service | URL | Kredensial |
|---------|-----|------------|
| QA Hub (Frontend) | http://localhost:3000 | - |
| Jenkins | http://localhost:8080/jenkins | admin / admin |

## Usage Guide

### Halaman Dashboard

Halaman utama dengan ringkasan statistik:
- Total builds
- Success rate
- Recent activity

### Halaman Scripts

1. **Melihat Daftar Script** - Semua script Playwright ditampilkan dan dikelompokkan per folder
2. **Mencari Script** - Gunakan search bar untuk filter berdasarkan nama file
3. **Menjalankan Script** - Klik tombol "Run" untuk eksekusi
4. **Upload Script Baru** - Klik "Upload Script" untuk upload file `.spec.ts`

### Live Log Viewer

Setelah menjalankan script, halaman live log menampilkan:
- Output real-time dari proses Playwright (Server-Sent Events)
- Color coding: Biru (INFO), Hijau (PASSED), Merah (FAILED), Kuning (WARNING)
- Tombol **Abort** untuk menghentikan proses
- Tombol **View Report** setelah build selesai

### Halaman History

Tabel riwayat semua run dengan kolom:
- Build ID, Script, Status, Environment, Browser, Duration, Date
- Action buttons: Logs, Report, Jenkins

## Docker Commands

```bash
# Start containers
docker compose up -d

# Stop containers (data tetap)
docker compose down

# Stop + hapus volumes (data hilang)
docker compose down -v

# Restart semua container
docker compose restart

# Rebuild image
docker compose build

# Rebuild tanpa cache
docker compose build --no-cache

# Lihat container yang berjalan
docker ps
```

## Project Structure

```
WebQA/
├── frontend/              # Next.js frontend application
├── backend/              # FastAPI backend (optional)
├── jenkins/              # Jenkins Docker configuration
├── playwright-runner/    # Playwright Docker runner
├── nginx/                # Nginx reverse proxy config
├── docker-compose.yml    # Multi-container setup
├── Automation Kantorku/  # Playwright test scripts
└── README.md
```

## Fitur Status

### Sudah Fungsional
- [x] Load script dari filesystem (Docker volume)
- [x] Jalankan script via UI Dashboard
- [x] Stream log real-time ke browser (SSE)
- [x] Abort run yang sedang berjalan
- [x] Status badge auto-update
- [x] Timer elapsed
- [x] Search/filter script
- [x] History terhubung ke Jenkins (real data)
- [x] Report viewer dengan iframe (Playwright HTML)
- [x] Link ke Jenkins build
- [x] Docker + Jenkins + Playwright pipeline
- [x] Upload script baru dari browser
- [x] Per-build report storage

### Belum Diimplementasi
- [ ] Allure Report integration
- [ ] Authentication/Login
- [ ] Database untuk persistent storage
- [ ] Script versioning / git integration

## Troubleshooting

**Q: Build gagal dengan error "No such container"?**
A: Playwright runner image belum di-build. Jalankan:
```bash
docker build -t playwright-runner:latest ./playwright-runner
```

**Q: Log SSE tidak update?**
A: Refresh halaman. SSE reconnect otomatis.

**Q: Upload script gagal?**
A: Pastikan file berekstensi `.spec.ts` dan volume automation_scripts sudah ter-mount dengan benar.

**Q: Jenkins job tidak berjalan?**
A: Restart Jenkins container:
```bash
docker compose restart jenkins
```

## License

Internal use only - Kantorku QA Team