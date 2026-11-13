// PLACEHOLDER. Replace by running `flutterfire configure` (it overwrites this
// file), or paste the values from Firebase Console > Project settings > Your apps.
// These client identifiers are not secrets; security comes from Firestore rules.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
  );

  static FirebaseOptions get currentPlatform => android;
}
