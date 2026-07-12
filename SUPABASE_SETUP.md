# Supabase Integration Guide

## 1) Create a Supabase project

1. Go to https://app.supabase.com and sign in or create an account.
2. Create a new project.
3. Choose a name and region, then create the project.

## 2) Get your Supabase URL and anon key

1. Open your project.
2. Go to `Settings` > `API`.
3. Copy the `Project URL`.
4. Copy the `anon public` key from `Config`.

## 3) Run the Flutter app with Supabase values

This app already uses `supabase_flutter` and reads two compile-time environment values in `lib/main.dart`:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Run the app with:

```powershell
flutter run --dart-define=SUPABASE_URL="https://your-project.supabase.co" --dart-define=SUPABASE_ANON_KEY="your-anon-public-key"
```

If you want to run on a specific device:

```powershell
flutter run -d chrome --dart-define=SUPABASE_URL="https://your-project.supabase.co" --dart-define=SUPABASE_ANON_KEY="your-anon-public-key"
```

## 4) Confirm Supabase auth settings

The app currently uses email/password signup with verification code flow. In Supabase:

1. Go to `Authentication` > `Settings`.
2. Make sure email confirmations are enabled if you want to use the verification flow.
3. Optional: set a friendly `Site URL` and `Sender Email`.

## 5) Create a test user

### Option A: Use the Supabase Console

1. Go to `Authentication` > `Users`.
2. Click `New user`.
3. Enter an email and password.
4. If you want the user confirmed immediately, enable `Confirm user`.

### Option B: Use the helper script in this repository

A helper script is available at `tool/create_supabase_test_user.dart`.

Use it with these environment variables:

```powershell
$env:SUPABASE_URL = "https://your-project.supabase.co"
$env:SUPABASE_SERVICE_ROLE_KEY = "your-service-role-key"
dart run tool/create_supabase_test_user.dart --email test@example.com --password Test1234!
```

The script will create a new Supabase auth user using the service role key.

## 6) Create your database tables

Supabase automatically creates a Postgres database for every project, so you do not need to create a separate database manually.

To add tables for the marketplace app, use the SQL editor in Supabase:

1. Open your Supabase project.
2. Go to `SQL` > `SQL Editor`.
3. Create a new query.
4. Copy the SQL from `supabase/schema.sql`.
5. Run the query.

This creates tables for:
- `profiles` (extended user profile data)
- `categories`
- `stores`
- `products`
- `reviews`
- `orders`
- `wishlist_items`
- `coupons`

## 7) Login from the app

1. Open the app.
2. Use the login screen.
3. Sign in with the user email and password you created.

## 8) Optional: Add a local `.env` workflow

If you later want environment variables in a file, keep your secrets out of source control and add `.env` to `.gitignore`.

---

## Notes

- The app already initializes Supabase in `lib/main.dart`.
- The auth logic is implemented in `lib/providers/auth_provider.dart`.
- The current app is only wired to Supabase for authentication. Product, cart, order, and wishlist data are still based on local sample data and shared preferences.
- If you want to load data from Supabase tables, I can update the app to query the new tables for products, orders, wishlist items, and cart data.
- If you want to use the service role key for admin actions, keep it secret and do not ship it in the app.
