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
    apiKey: 'AIzaSyDpBhqGriRKbA6cHRxnbZGEOmUrRsS9bwg',
    appId: '1:813360610878:web:516ad95be6ef9161ab9b6f',
    messagingSenderId: '813360610878',
    projectId: 'clockin-f9343',
    authDomain: 'clockin-f9343.firebaseapp.com',
    databaseURL: 'https://clockin-f9343-default-rtdb.firebaseio.com',
    storageBucket: 'clockin-f9343.firebasestorage.app',
    measurementId: 'G-2WBGGD0903',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBU9HBc1d__WLsSLBz4lzxk3Dfj4VW9PtE',
    appId: '1:813360610878:android:0d8e445c61590f64ab9b6f',
    messagingSenderId: '813360610878',
    projectId: 'clockin-f9343',
    databaseURL: 'https://clockin-f9343-default-rtdb.firebaseio.com',
    storageBucket: 'clockin-f9343.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuaijJS6r5P7q8oD8ZREEzQlsAyfTkhAI',
    appId: '1:813360610878:ios:973149ca0141b22dab9b6f',
    messagingSenderId: '813360610878',
    projectId: 'clockin-f9343',
    databaseURL: 'https://clockin-f9343-default-rtdb.firebaseio.com',
    storageBucket: 'clockin-f9343.firebasestorage.app',
    androidClientId: '813360610878-11kbv7rhvve2hpn9amijrsb4gklh8q78.apps.googleusercontent.com',
    iosClientId: '813360610878-k0rntuqmkijqr8sicpqga2k59g7nkc1q.apps.googleusercontent.com',
    iosBundleId: 'com.example.clockinAdmin',
  );

}