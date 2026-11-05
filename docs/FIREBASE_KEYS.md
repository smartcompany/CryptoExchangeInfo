# Firebase client API keys

GitHub may flag `AIza…` strings as “Google API Key”. For **Firebase mobile client** keys this is usually a **false positive**.

Per [Firebase docs](https://firebase.google.com/docs/projects/api-keys):

- Client API keys **identify** the project/app; they are **not** authorization secrets.
- Access is enforced by Security Rules, App Check, and **API / app restrictions**.
- It is normal for keys to live in `google-services.json` / `GoogleService-Info.plist`.

## What we do in Exora

- Dart no longer embeds keys in `lib/firebase_options.dart`.
- `Firebase.initializeApp()` uses native plist / google-services files.

## Close the GitHub alert

1. Push the commit that removes keys from `firebase_options.dart`.
2. In the alert → **Close as** → *False positive* (or *Used in tests* N/A) and note “Firebase client API key”.
3. Optional hardening in [Google Cloud Console → APIs & Services → Credentials](https://console.cloud.google.com/apis/credentials):
   - Android key: restrict to app package + SHA-1
   - iOS key: restrict to bundle id `com.smartcompany.cryptoExchangeInfo`
   - API restrictions: Firebase-related APIs only (do **not** allow Gemini on these keys)

## When to rotate

Rotate/regenerate only if the same key was also allowlisted for **billable non-Firebase APIs** (e.g. Gemini, Maps). Otherwise restriction is enough.
