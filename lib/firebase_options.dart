// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD-GdYSdJd1vOk8HYPWEHYpEeTa8Mvq4_4',
    appId: '1:1098217591910:web:edaa779e0ed7eb691389a7',
    messagingSenderId: '1098217591910',
    projectId: 'authenticationwith-e58ee',
    authDomain: 'authenticationwith-e58ee.firebaseapp.com',
    storageBucket: 'authenticationwith-e58ee.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtsPbBORx5mTZfpqLCzLnYOGUS_wPcAwQ',
    appId: '1:1098217591910:android:8653a8b07b88018c1389a7',
    messagingSenderId: '1098217591910',
    projectId: 'authenticationwith-e58ee',
    storageBucket: 'authenticationwith-e58ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUIK9NRJxdbBT29BfiGS8Wn9H8Vu44guw',
    appId: '1:1098217591910:ios:b6af1aca38146a871389a7',
    messagingSenderId: '1098217591910',
    projectId: 'authenticationwith-e58ee',
    storageBucket: 'authenticationwith-e58ee.appspot.com',
    iosBundleId: 'com.example.authenticationGoogle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAUIK9NRJxdbBT29BfiGS8Wn9H8Vu44guw',
    appId: '1:1098217591910:ios:b6af1aca38146a871389a7',
    messagingSenderId: '1098217591910',
    projectId: 'authenticationwith-e58ee',
    storageBucket: 'authenticationwith-e58ee.appspot.com',
    iosBundleId: 'com.example.authenticationGoogle',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-GdYSdJd1vOk8HYPWEHYpEeTa8Mvq4_4',
    appId: '1:1098217591910:web:3d3f10b18826bd8f1389a7',
    messagingSenderId: '1098217591910',
    projectId: 'authenticationwith-e58ee',
    authDomain: 'authenticationwith-e58ee.firebaseapp.com',
    storageBucket: 'authenticationwith-e58ee.appspot.com',
  );
}
