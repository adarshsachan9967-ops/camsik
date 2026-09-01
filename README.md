# CASMIK Ecosystem

Casmik is an all-in-one platform for device buyback, refurbished device sales, repairs, partner management, and delivery logistics.

## Project Structure

```
casmik/
├── casmik/              # Next.js 15 Web Application & Backend API
├── casmikadmin/         # Flutter Admin Management App
├── casmikcustomer/      # Flutter Customer App
├── casmikexec/          # Flutter Executive / Delivery App
├── casmikpartner/       # Flutter Partner / Merchant App
├── atlas-credentials.env# MongoDB Atlas Credentials
├── .env                 # Project Environment Configuration
└── .env.example         # Environment Template
```

## Tech Stack & Integrations

- **Web Frontend & API**: Next.js 15, React 19, Tailwind CSS, TypeScript
- **Mobile Applications**: Flutter & Dart (Sizer, GoRouter, CachedNetworkImage)
- **Database**: MongoDB Atlas
- **Storage & CDN**: ImageKit (Folder: `casmik`)
- **Authentication**: Supabase SSR / Client Auth

## Getting Started

### Web App (`casmik`)
```bash
cd casmik
npm install
npm run dev
```

### Mobile Apps (`casmikadmin`, `casmikcustomer`, `casmikexec`, `casmikpartner`)
```bash
cd casmikadmin # or casmikcustomer, casmikexec, casmikpartner
flutter pub get
flutter run
```
