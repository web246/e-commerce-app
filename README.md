# Vendi

Multi-vendor marketplace. React Native (Android/iOS) + Next.js (Web). Firebase backend.

## Architecture

```
vendi/
  apps/
    mobile/          React Native (Expo) — Android & iOS
    web/             Next.js 14 — Web
  packages/
    shared/          Types, hooks, Firebase layer, design tokens
```

## Shared package (`@vendi/shared`)

Every screen across mobile and web uses the same:
- **Design tokens** — colors, typography, spacing, radii, motion
- **TypeScript types** — User, Product, Order, Review, etc.
- **Firebase layer** — Firestore queries, auth, storage
- **React hooks** — useAuth, useProducts, useReviews, useOrders

Zero hardcoded data. Every rating is computed from actual reviews. Every product list comes from Firestore. Every number on screen is queried or computed.

## Firebase collections

| Collection | Purpose |
|---|---|
| `products` | Product catalog with computed rating/reviewCount |
| `users` | User profiles (role, addresses, avatar) |
| `orders` | Orders with timeline, items, status |
| `stores` | Seller store profiles |
| `categories` | Product categories |
| `reviews` | Product reviews (rating drives product.rating) |
| `carts` | Per-user cart (userId document, items array) |
| `wishlists` | Per-user wishlist (userId document, productIds array) |
| `coupons` | Discount codes (type, value, expiry) |

## Getting started

### Prerequisites
- Node.js 18+
- Firebase project (console.firebase.google.com)
- Expo CLI (`npm install -g expo-cli`)

### Setup
```bash
# Install all dependencies
npm install

# Configure Firebase
# Edit packages/shared/src/firebase/config.ts with your Firebase config
# Or use Firebase emulators for local dev

# Run mobile app (Expo)
cd apps/mobile
npx expo start

# Run web app
cd apps/web
npm run dev
```

### Adding seed data
Use the Firebase console or the Admin SDK to seed products, categories, and coupons into Firestore.

## Design principles
- **Dynamic over hardcoded** — no product names, ratings, or counts are hardcoded
- **Computed over stored** — ratings are averages of actual reviews
- **Tokens over inline** — every color, spacing, and font comes from the design token system
- **Hooks over direct calls** — screens use hooks (useProducts, useAuth) not raw Firebase calls
