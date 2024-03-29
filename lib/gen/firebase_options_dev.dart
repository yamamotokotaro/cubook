// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCZxE0rvVm1Ni4WNFFaNqaqBmRjxGWdJmk',
    appId: '1:593398023204:web:7c59ada1410f59608b04b1',
    messagingSenderId: '593398023204',
    projectId: 'cubook-dev',
    authDomain: 'cubook-dev.firebaseapp.com',
    databaseURL: 'https://cubook-dev.firebaseio.com',
    storageBucket: 'cubook-dev.appspot.com',
    measurementId: 'G-GRLGN4P1QM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGSD9SDkTRvts_tjBhT1mn6FVGVk3qW4M',
    appId: '1:593398023204:android:4ce645d12832b9038b04b1',
    messagingSenderId: '593398023204',
    projectId: 'cubook-dev',
    databaseURL: 'https://cubook-dev.firebaseio.com',
    storageBucket: 'cubook-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArqdXRPGNr5E9lcs5oeWP8bqFO7NpwO3c',
    appId: '1:593398023204:ios:93a166d4d03669758b04b1',
    messagingSenderId: '593398023204',
    projectId: 'cubook-dev',
    databaseURL: 'https://cubook-dev.firebaseio.com',
    storageBucket: 'cubook-dev.appspot.com',
    androidClientId: '593398023204-p5p9qgnhuetducg6eoj2o7r9q7r55pgr.apps.googleusercontent.com',
    iosClientId: '593398023204-nppp5euqn97a66ieb1941799ctv9j2fd.apps.googleusercontent.com',
    iosBundleId: 'app.kotakota.cubook.dev',
  );
}
