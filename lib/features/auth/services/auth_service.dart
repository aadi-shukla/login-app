import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign up with email, password, and name.
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        )
        .timeout(const Duration(seconds: 30));

    // Non-critical updates during sign up, use short timeouts to avoid hanging
    try {
      if (credential.user != null) {
        await credential.user!
            .updateDisplayName(displayName.trim())
            .timeout(const Duration(seconds: 5), onTimeout: () => null);

        await credential.user!
            .reload()
            .timeout(const Duration(seconds: 3), onTimeout: () => null);

        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'displayName': displayName.trim(),
          'email': email.trim(),
          'photoUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 15), onTimeout: () => null);
      }
    } catch (e) {
      debugPrint("AuthService (signUp non-critical steps): $e");
    }

    return credential;
  }

  /// Sign in with email and password.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth
        .signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        )
        .timeout(const Duration(seconds: 30));
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Fetch user profile from Firestore.
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 60));
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      debugPrint("AuthService (fetchUserProfile): $e");
    }
    return null;
  }

  /// Update user profile in both Firebase Auth and Firestore.
  Future<void> updateUserProfile({
    required String displayName,
    required String phoneNumber,
    required String bio,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Update Firebase Auth display name
    await user.updateDisplayName(displayName.trim());

    // Update Firestore using set with merge to handle cases where doc might not exist
    await _firestore.collection('users').doc(user.uid).set({
      'displayName': displayName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'bio': bio.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)).timeout(const Duration(seconds: 15));

    await user
        .reload()
        .timeout(const Duration(seconds: 3), onTimeout: () => null);
  }

  /// Get auth/firestore error message as a user-friendly string.
  String getErrorMessage(Object error) {
    String code = '';
    if (error is FirebaseAuthException) {
      code = error.code;
    } else if (error is FirebaseException) {
      code = error.code;
    } else {
      code = error.toString();
    }
    // debugPrint("AuthService (getErrorMessage): $code");

    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'permission-denied':
        return 'Permission denied. Please enable Cloud Firestore in your Firebase Console.';
      case 'unavailable':
        return 'Service unavailable. Check your internet or Firebase status.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      default:
        if (code.contains('TimeoutException')) {
          return 'Request timed out. Please check your internet connection.';
        }
        return code;
    }
  }
}
