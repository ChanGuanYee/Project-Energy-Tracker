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
    apiKey: 'AIzaSyDUxtN-PEt7sEMJeTkN9DUrrYpoJYS3fKQ',
    appId: '1:75134242949:web:8a4aaa382522ff3c2859ec',
    messagingSenderId: '75134242949',
    projectId: 'projectenergytracker',
    authDomain: 'projectenergytracker.firebaseapp.com',
    storageBucket: 'projectenergytracker.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAbXm4BRkqeQ3WVgSIygnwHOrU7Cc0V1s',
    appId: '1:75134242949:android:f67d5cd558bffb9b2859ec',
    messagingSenderId: '75134242949',
    projectId: 'projectenergytracker',
    storageBucket: 'projectenergytracker.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAO2R4WmuuZGb4uD6k3MZtesHEN9aLLEqY',
    appId: '1:75134242949:ios:1892176c74875a942859ec',
    messagingSenderId: '75134242949',
    projectId: 'projectenergytracker',
    storageBucket: 'projectenergytracker.firebasestorage.app',
    iosBundleId: 'com.example.projectEnergytracker',
  );
}
