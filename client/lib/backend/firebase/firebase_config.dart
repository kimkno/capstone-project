import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDywoiC7wF_TfwI1IacbZsLtx-fHYv6Pc8",
            authDomain: "capstone-auth-a183b.firebaseapp.com",
            projectId: "capstone-auth-a183b",
            storageBucket: "capstone-auth-a183b.firebasestorage.app",
            messagingSenderId: "222666551182",
            appId: "1:222666551182:web:fee1a3221fc38b3c613edf"));
  } else {
    await Firebase.initializeApp();
  }
}
