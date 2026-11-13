# MOQMate

Buy Together. Pay Less. Grow Together.

Status: **Phase 2 of 8** (authentication, roles, location). See "What works" below.

## 1. Create the Firebase project (about 10 minutes, free Spark plan)

1. https://console.firebase.google.com > Add project > `moqmate` (Analytics optional).
2. Build > Authentication > Get started > enable **Email/Password**.
3. Build > Firestore Database > Create database > production mode > pick the region closest to your users.
4. Firestore > Rules tab > paste the contents of `firestore.rules` > Publish.
5. Project settings > Your apps > add an **Android** app with package name `com.moqmate.moqmate`.
6. Copy the values shown for the app (apiKey, appId, messagingSenderId, projectId, storageBucket)
   into `lib/firebase_options.dart`, replacing each `REPLACE_ME`.
   (Or run `flutterfire configure` locally, which writes that file for you.)

These client identifiers are not secrets. Security comes from the Firestore rules and Auth.
Never put a service-account key in this repo.

## 2. Get the APK (GitHub Actions)

1. Create a GitHub repository and push this folder to branch `main`.
2. Open the repo > Actions > "Build debug APK". It runs automatically on push.
3. When it finishes, download the `moqmate-debug-apk` artifact, unzip, and copy
   `app-debug.apk` to your phone. Allow "install unknown apps" when prompted.

If the build fails, open the failed step and send me the log. I will fix it.

## 3. Local build alternative

    flutter create --platforms=android --org com.moqmate --project-name moqmate .
    flutter pub get && flutter test && flutter build apk --debug

## 4. How to test Phase 2 on your phone

| Step | Expected |
|---|---|
| First launch | Splash, then 3 onboarding screens, then Login |
| Register with a bad email / short password | Inline validation errors, no network call |
| Register a valid account | Goes to Location screen |
| Pick country, then city | City list changes with country; Continue enabled only when both chosen |
| Pick Buyer | Buyer mode screen |
| Sign out, register another account, pick Supplier | Business name required; Supplier mode screen |
| Third account, pick Both | Switch button toggles Buyer/Supplier mode |
| Wrong password on login | "Incorrect email or password." |
| Airplane mode, then sign in | "No internet connection..." message |
| Kill and reopen the app while signed in | Returns straight to your mode screen |

## 5. What works / what does not (honest status)

Implemented in code (NOT yet run on a device by me; this sandbox cannot build Android):
- Email/password registration, login, logout, password-reset email
- Firestore user profile, country/city selection, role selection (Buyer/Supplier/Both)
- Mode switching for "Both" accounts
- Role-based route guards (a buyer cannot open supplier routes)
- Firestore security rules for the `users` collection
- Unit tests: validators, user model, routing/guard rules (run in CI)

Placeholders: the Buyer/Supplier screens are status shells only. Real dashboards come in Phase 3.
Not started: marketplace, requests, offers, groups, matching, payments, orders, tracking, notifications.

Known limitation: country/city is chosen once at sign-up in this phase; editing it comes with Settings in Phase 7.
Self-chosen account type is stored on the user document; an admin/verification layer for suppliers is not in scope yet.
