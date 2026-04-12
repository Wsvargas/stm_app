import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyClqtGEoHLRt4GfziNDahOIsbv2MO2gAnk',
    authDomain: 'stm-app-cihe.firebaseapp.com',
    projectId: 'stm-app-cihe',
    storageBucket: 'stm-app-cihe.firebasestorage.app',
    messagingSenderId: '538559006995',
    appId: '1:538559006995:web:fd29036d9e6b04db5472e6',
    measurementId: 'G-QF0WMYBN72',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClqtGEoHLRt4GfziNDahOIsbv2MO2gAnk',
    authDomain: 'stm-app-cihe.firebaseapp.com',
    projectId: 'stm-app-cihe',
    storageBucket: 'stm-app-cihe.firebasestorage.app',
    messagingSenderId: '538559006995',
    appId: '1:538559006995:web:fd29036d9e6b04db5472e6',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClqtGEoHLRt4GfziNDahOIsbv2MO2gAnk',
    authDomain: 'stm-app-cihe.firebaseapp.com',
    projectId: 'stm-app-cihe',
    storageBucket: 'stm-app-cihe.firebasestorage.app',
    messagingSenderId: '538559006995',
    appId: '1:538559006995:web:fd29036d9e6b04db5472e6',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyClqtGEoHLRt4GfziNDahOIsbv2MO2gAnk',
    authDomain: 'stm-app-cihe.firebaseapp.com',
    projectId: 'stm-app-cihe',
    storageBucket: 'stm-app-cihe.firebasestorage.app',
    messagingSenderId: '538559006995',
    appId: '1:538559006995:web:fd29036d9e6b04db5472e6',
    measurementId: 'G-QF0WMYBN72',
  );
}
