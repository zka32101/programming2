import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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

  // kore1プロジェクトのWeb設定
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCjpHo46GeJzN_TMINl1eaMNJet3QFXr_U',
    appId: '1:906257233334:web:0c9d94f157252096c88fc4',
    messagingSenderId: '906257233334',
    projectId: 'kore1-6b58e',
    storageBucket: 'kore1-6b58e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjpHo46GeJzN_TMINl1eaMNJet3QFXr_U',
    appId: '1:906257233334:android:2e17f224a0f8a7e41ffd17',
    messagingSenderId: '906257233334',
    projectId: 'kore1-6b58e',
    storageBucket: 'kore1-6b58e.firebasestorage.app',
  );

  // kore1プロジェクトのiOS設定
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjpHo46GeJzN_TMINl1eaMNJet3QFXr_U',
    appId: '1:906257233334:ios:2e17f224a0f8a7e41ffd17',
    messagingSenderId: '906257233334',
    projectId: 'kore1-6b58e',
    storageBucket: 'kore1-6b58e.firebasestorage.app',
    iosBundleId: 'com.yourwish.shougakukore.kokugo',
  );
}
