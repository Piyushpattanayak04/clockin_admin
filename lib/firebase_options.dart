// Replace with your actual Firebase config values
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
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
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    authDomain: 'YOUR_AUTH_DOMAIN',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    appId: 'YOUR_APP_ID',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBU9HBc1d__WLsSLBz4lzxk3Dfj4VW9PtE',
    appId: '1:813360610878:android:0d8e445c61590f64ab9b6f',
    messagingSenderId: '813360610878',
    projectId: 'clockin-f9343',
    storageBucket: 'clockin-f9343.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuaijJS6r5P7q8oD8ZREEzQlsAyfTkhAI',
    appId: '1:813360610878:ios:973149ca0141b22dab9b6f',
    messagingSenderId: '813360610878',
    projectId: 'clockin-f9343',
    storageBucket: 'clockin-f9343.firebasestorage.app',
    iosBundleId: 'com.example.clockinAdmin',
  );

}