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
    apiKey: 'AIzaSyAHXqHXQUcgAX5z2svMtjTEU-E1yMHl6Z4',
    appId: '1:538051519572:web:8dd80f3b251a26d30179c1',
    messagingSenderId: '538051519572',
    projectId: 'mapp-df3dc',
    authDomain: 'mapp-df3dc.firebaseapp.com',
    storageBucket: 'mapp-df3dc.appspot.com',
    measurementId: 'G-CFT5JCPM3H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-UZV8YeWtdFx_6fvciznHYH10gBBDPSo',
    appId: '1:538051519572:android:0c6029b80da0958a0179c1',
    messagingSenderId: '538051519572',
    projectId: 'mapp-df3dc',
    storageBucket: 'mapp-df3dc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKac_2kk64TP9Y6W4cwbJyN4s8JaqvIyw',
    appId: '1:538051519572:ios:6f60c64ebcc76b1b0179c1',
    messagingSenderId: '538051519572',
    projectId: 'mapp-df3dc',
    storageBucket: 'mapp-df3dc.appspot.com',
    iosBundleId: 'com.example.mapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKac_2kk64TP9Y6W4cwbJyN4s8JaqvIyw',
    appId: '1:538051519572:ios:6f60c64ebcc76b1b0179c1',
    messagingSenderId: '538051519572',
    projectId: 'mapp-df3dc',
    storageBucket: 'mapp-df3dc.appspot.com',
    iosBundleId: 'com.example.mapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHXqHXQUcgAX5z2svMtjTEU-E1yMHl6Z4',
    appId: '1:538051519572:web:fa5d35aedf9155f40179c1',
    messagingSenderId: '538051519572',
    projectId: 'mapp-df3dc',
    authDomain: 'mapp-df3dc.firebaseapp.com',
    storageBucket: 'mapp-df3dc.appspot.com',
    measurementId: 'G-N6VN6THDSK',
  );
}
