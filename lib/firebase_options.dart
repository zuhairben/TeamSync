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
    apiKey: 'AIzaSyAaDqqRmNYVKJbHHGTCNpPI6PB-9wTHmeU',
    appId: '1:592443343203:web:55dcc6e822bdb0573f1356',
    messagingSenderId: '592443343203',
    projectId: 'fir-setup-ec898',
    authDomain: 'fir-setup-ec898.firebaseapp.com',
    storageBucket: 'fir-setup-ec898.firebasestorage.app',
    measurementId: 'G-TCTVT7RMM7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMerEFwSIRJwB2pqJ_nFDZ9ZcBmPnD5YQ',
    appId: '1:592443343203:android:c065ca0385aadec73f1356',
    messagingSenderId: '592443343203',
    projectId: 'fir-setup-ec898',
    storageBucket: 'fir-setup-ec898.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPWboMXZEyF0Q7zRb7fpugFl-X7PP98iI',
    appId: '1:592443343203:ios:8c8002036693d2c23f1356',
    messagingSenderId: '592443343203',
    projectId: 'fir-setup-ec898',
    storageBucket: 'fir-setup-ec898.firebasestorage.app',
    iosClientId: '592443343203-327dia80l956p5pfk3o7drsirarbs5nr.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPWboMXZEyF0Q7zRb7fpugFl-X7PP98iI',
    appId: '1:592443343203:ios:8c8002036693d2c23f1356',
    messagingSenderId: '592443343203',
    projectId: 'fir-setup-ec898',
    storageBucket: 'fir-setup-ec898.firebasestorage.app',
    iosClientId: '592443343203-327dia80l956p5pfk3o7drsirarbs5nr.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAaDqqRmNYVKJbHHGTCNpPI6PB-9wTHmeU',
    appId: '1:592443343203:web:bca119aef7c3b1ba3f1356',
    messagingSenderId: '592443343203',
    projectId: 'fir-setup-ec898',
    authDomain: 'fir-setup-ec898.firebaseapp.com',
    storageBucket: 'fir-setup-ec898.firebasestorage.app',
    measurementId: 'G-RWMYWHGX3K',
  );
}