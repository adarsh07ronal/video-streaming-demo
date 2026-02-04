# 🎬 Video Streaming Demo (Rails + Flutter)

A full-stack video streaming demo showcasing:
- Secure direct uploads to S3 using presigned URLs
- Metadata storage in PostgreSQL
- Dynamic video streaming via presigned GET URLs
- Flutter-based video player client

---

## 🧱 Architecture Overview

- **Backend**: Ruby on Rails (API-only)
- **Storage**: AWS S3
- **Auth**: JWT (Google OAuth ready)
- **Client**: Flutter (Android emulator)
- **Streaming**: Presigned URLs

---

## 🔄 Flow

1. Client requests upload URL
2. Rails generates S3 presigned URL
3. Client uploads directly to S3
4. Metadata stored in DB
5. Client requests stream URL
6. Rails returns presigned GET URL
7. Flutter streams video

---

## 🚀 Future Improvements

- CloudFront CDN
- HLS adaptive streaming
- Background transcoding (MediaConvert)
- DRM & analytics

---

## ▶️ Demo

- Upload → Stream → Switch videos dynamically
- Two videos supported (short + long demo)

---

## ⚠️ Security Notes

Secrets are stored in environment variables.
No AWS credentials are committed.

---

## Architecture

        ┌──────────────────────┐
        │     Flutter App      │
        │  (Android Emulator) │
        │---------------------│
        │  • Video Player     │
        │  • Upload Button   │
        │  • Switch Videos   │
        └─────────┬──────────┘
                  │
      Request presigned URL
                  │
                  ▼
        ┌──────────────────────┐
        │      Rails API       │
        │    (API-only)        │
        │---------------------│
        │  • Auth (Google)    │
        │  • Presign Service  │
        │  • Videos API       │
        └───────┬───────┬─────┘
                │       │
     Save meta  │       │ Generate URL
                ▼       ▼
        ┌────────────┐  ┌──────────────────────┐
        │ PostgreSQL │  │        AWS S3         │
        │------------│  │----------------------│
        │ users      │  │ • Video files        │
        │ videos     │  │ • PUT (upload)       │
        └────────────┘  │ • GET (stream)       │
                         └──────────────────────┘
Pending
HLS
Cloudfront
Transcoding

## 👨‍💻 Author

Adarsh Ramakrishna
