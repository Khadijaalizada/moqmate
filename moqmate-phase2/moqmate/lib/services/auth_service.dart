import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class AuthService {
  AuthService(this._auth, this._db);
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _db.collection('users').doc(uid);

  Future<void> register({required String name, required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    final user = cred.user!;
    await user.updateDisplayName(name.trim());
    await _doc(user.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    final user = cred.user!;
    // Repair case: account exists but the profile document was never written.
    final snap = await _doc(user.uid).get();
    if (!snap.exists) {
      await _doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email ?? email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> sendPasswordReset(String email) => _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signOut() => _auth.signOut();

  Future<void> saveLocation(String uid, String country, String city) =>
      _doc(uid).update({'country': country, 'city': city});

  Future<void> saveRole(String uid, AccountType type, {String? businessName}) {
    final data = <String, dynamic>{
      'accountType': type.name,
      'activeMode': type == AccountType.supplier ? 'supplier' : 'buyer',
    };
    if (type != AccountType.buyer && businessName != null) {
      data['businessName'] = businessName.trim();
    }
    return _doc(uid).update(data);
  }

  Future<void> setMode(String uid, AppMode mode) => _doc(uid).update({'activeMode': mode.name});

  static String messageFor(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'That email address is not valid.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account with this email already exists.';
        case 'weak-password':
          return 'Password is too weak. Use at least 8 characters.';
        case 'network-request-failed':
          return 'No internet connection. Check your network and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'user-disabled':
          return 'This account has been disabled.';
        default:
          return e.message ?? 'Authentication failed (${e.code}).';
      }
    }
    if (e is FirebaseException) {
      return e.code == 'permission-denied'
          ? 'You do not have permission to do that.'
          : (e.message ?? 'Server error (${e.code}).');
    }
    return 'Something went wrong. Please try again.';
  }
}
