// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCy7on5EpqnCihnMKNzG4DGX7YIrebheYc',
    appId: '1:753196410884:web:1d77ce9646ea195c4d2d51',
    messagingSenderId: '753196410884',
    projectId: 'cubook-3c960',
    authDomain: 'cubook-3c960.firebaseapp.com',
    databaseURL: 'https://cubook-3c960.firebaseio.com',
    storageBucket: 'cubook-3c960.appspot.com',
    measurementId: 'G-CSRSP18WRC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_S_Pr9-QIqFhpz_QEVl7iFyceJ4-sYYM',
    appId: '1:753196410884:android:c0420c546e6be2384d2d51',
    messagingSenderId: '753196410884',
    projectId: 'cubook-3c960',
    databaseURL: 'https://cubook-3c960.firebaseio.com',
    storageBucket: 'cubook-3c960.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAK6uPDz6q2KbSdZUdmPkQ4mliWOXE3ea0',
    appId: '1:753196410884:ios:33bea3fafc1800be4d2d51',
    messagingSenderId: '753196410884',
    projectId: 'cubook-3c960',
    databaseURL: 'https://cubook-3c960.firebaseio.com',
    storageBucket: 'cubook-3c960.appspot.com',
    androidClientId: '753196410884-3sl2ttqinag71v41bg4d57nea0sfit9q.apps.googleusercontent.com',
    iosClientId: '753196410884-jlmbkbv1enkm2vliuk300nq98p7rf6gv.apps.googleusercontent.com',
    iosBundleId: 'app.kotakota.cubook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAK6uPDz6q2KbSdZUdmPkQ4mliWOXE3ea0',
    appId: '1:753196410884:ios:33bea3fafc1800be4d2d51',
    messagingSenderId: '753196410884',
    projectId: 'cubook-3c960',
    databaseURL: 'https://cubook-3c960.firebaseio.com',
    storageBucket: 'cubook-3c960.appspot.com',
    androidClientId: '753196410884-3sl2ttqinag71v41bg4d57nea0sfit9q.apps.googleusercontent.com',
    iosClientId: '753196410884-jlmbkbv1enkm2vliuk300nq98p7rf6gv.apps.googleusercontent.com',
    iosBundleId: 'app.kotakota.cubook',
  );
}
