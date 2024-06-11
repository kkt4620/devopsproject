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
    apiKey: 'AIzaSyCRhAXwhlIkyoRhv1epgjW1XIoeMzNkXaU',
    appId: '1:892120874290:web:179c87e5edecdc2fd16b2b',
    messagingSenderId: '892120874290',
    projectId: 'devops-project-3d0d7',
    authDomain: 'devops-project-3d0d7.firebaseapp.com',
    databaseURL: 'https://devops-project-3d0d7-default-rtdb.firebaseio.com',
    storageBucket: 'devops-project-3d0d7.appspot.com',
    measurementId: 'G-WQPMKJ2GSH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDU6YzO88Jd7IVDEwAXa3YpPGo_UxcgCt4',
    appId: '1:892120874290:android:0dbcfb6d5f4e3134d16b2b',
    messagingSenderId: '892120874290',
    projectId: 'devops-project-3d0d7',
    databaseURL: 'https://devops-project-3d0d7-default-rtdb.firebaseio.com',
    storageBucket: 'devops-project-3d0d7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJgp42GdA4_ZUUkc8ZzM1BPnWSWcUcTh8',
    appId: '1:892120874290:ios:57c9253c28903318d16b2b',
    messagingSenderId: '892120874290',
    projectId: 'devops-project-3d0d7',
    databaseURL: 'https://devops-project-3d0d7-default-rtdb.firebaseio.com',
    storageBucket: 'devops-project-3d0d7.appspot.com',
    iosBundleId: 'com.example.swg',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJgp42GdA4_ZUUkc8ZzM1BPnWSWcUcTh8',
    appId: '1:892120874290:ios:57c9253c28903318d16b2b',
    messagingSenderId: '892120874290',
    projectId: 'devops-project-3d0d7',
    databaseURL: 'https://devops-project-3d0d7-default-rtdb.firebaseio.com',
    storageBucket: 'devops-project-3d0d7.appspot.com',
    iosBundleId: 'com.example.swg',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCRhAXwhlIkyoRhv1epgjW1XIoeMzNkXaU',
    appId: '1:892120874290:web:09038f8298bfddfed16b2b',
    messagingSenderId: '892120874290',
    projectId: 'devops-project-3d0d7',
    authDomain: 'devops-project-3d0d7.firebaseapp.com',
    databaseURL: 'https://devops-project-3d0d7-default-rtdb.firebaseio.com',
    storageBucket: 'devops-project-3d0d7.appspot.com',
    measurementId: 'G-C8W3SQ1P3C',
  );
}