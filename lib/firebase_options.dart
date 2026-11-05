import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Firebase is not configured for web in Exora.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMiWLbYXd5QbRHPxkMpY30GXCR-qZZ2GY',
    appId: '1:141250947054:android:61792d8ff38cb9f7b490ff',
    messagingSenderId: '141250947054',
    projectId: 'cryptoexchangeinfo',
    storageBucket: 'cryptoexchangeinfo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVMQuO6TT-GZryCbBkh0KoWMMbZ7AxPmI',
    appId: '1:141250947054:ios:3623ea0753c0c874b490ff',
    messagingSenderId: '141250947054',
    projectId: 'cryptoexchangeinfo',
    storageBucket: 'cryptoexchangeinfo.firebasestorage.app',
    iosBundleId: 'com.smartcompany.cryptoExchangeInfo',
  );
}
