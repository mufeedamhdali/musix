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
    apiKey: 'AIzaSyCLxUzu8l77QoF6LFUi1IokiaSyG8Laffo',
    appId: '1:822647436695:web:98d3f9b445a877be4900d2',
    messagingSenderId: '822647436695',
    projectId: 'musix-cd645',
    authDomain: 'musix-cd645.firebaseapp.com',
    storageBucket: 'musix-cd645.appspot.com',
    measurementId: 'G-CXCMSM3Z39',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxda50NFcYxxXuk8vtGegOtipiOF902kI',
    appId: '1:822647436695:android:465e9c62fbc2d0b44900d2',
    messagingSenderId: '822647436695',
    projectId: 'musix-cd645',
    storageBucket: 'musix-cd645.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ6kHox5StR_SGikzjysy8qPZmjbAs3gc',
    appId: '1:822647436695:ios:a69d80a0b5d98d734900d2',
    messagingSenderId: '822647436695',
    projectId: 'musix-cd645',
    storageBucket: 'musix-cd645.appspot.com',
    iosBundleId: 'com.mufeeda.musix',
  );
}
