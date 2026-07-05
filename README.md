# DOMS Distributed

Distributed Organization Management System

---

## Teknologi

- PostgreSQL 16
- PostgreSQL FDW
- PostgreSQL Logical Replication
- MongoDB 4.4
- Redis 7
- Docker Compose

---

## Node

### Node 1

Kemahasiswaan

### Node 2

BEM

### Node 3

HIMA

### Node 4

UKM

---

## Fitur

- Login User
- Surat Organisasi
- Proposal Kegiatan
- Approval Surat
- Approval Proposal
- Kalender Organisasi
- Audit Log MongoDB
- Redis Cache
- FDW
- Horizontal Fragmentation
- Vertical Fragmentation
- Logical Replication

---

## Menjalankan Project

```bash
docker compose up -d
```

Melihat container

```bash
docker ps
```

Masuk Node Kampus

```bash
docker exec -it node1-campus psql -U postgres -d campus_db
```

Masuk Node BEM

```bash
docker exec -it node2-bem psql -U postgres -d bem_db
```

Masuk Node HIMA

```bash
docker exec -it node3-hima psql -U postgres -d hima_db
```

Masuk Node UKM

```bash
docker exec -it node4-ukm psql -U postgres -d ukm_db
```

Redis

```bash
docker exec -it redis redis-cli
```

MongoDB

```bash
docker exec -it mongodb mongosh
```

---

## Struktur

```
database/
docker/
mongodb/
redis/
scripts/
terminal-demo/
docs/
```

---

## Target

Project ini dibuat sebagai implementasi Database Terdistribusi menggunakan PostgreSQL, Redis, MongoDB, Fragmentasi, Replikasi, dan Foreign Data Wrapper (FDW).

Target implementasi adalah demonstrasi melalui terminal.