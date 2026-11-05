// Firebase is initialized from native config files:
// - android/app/google-services.json
// - ios/Runner/GoogleService-Info.plist
//
// Do not put Google API keys in this Dart file — GitHub secret scanning
// flags them, and Firebase documents client API keys as non-secret identifiers
// when restricted to Firebase APIs + app (package / bundle) restrictions.
//
// See: https://firebase.google.com/docs/projects/api-keys
//
// Kept as a stub so older imports fail loudly if reintroduced.
@Deprecated('Use Firebase.initializeApp() without options on iOS/Android')
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();
}
