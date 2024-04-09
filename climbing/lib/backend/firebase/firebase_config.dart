import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBc3CiUVWHqCbepRH8I5QJw613HmCD6_jA",
            authDomain: "climbing-ah1dsd.firebaseapp.com",
            projectId: "climbing-ah1dsd",
            storageBucket: "climbing-ah1dsd.appspot.com",
            messagingSenderId: "132008850959",
            appId: "1:132008850959:web:4498b64ef75fd50d7dd57a"));
  } else {
    await Firebase.initializeApp();
  }
}
