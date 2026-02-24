import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lara/core/errors/exceptions.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._auth, this.firestore, this._google);

  final FirebaseAuth _auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn _google;

  Stream<User?> watchAuthState() => _auth.authStateChanges();

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithGoogleAndLinkIfNeeded({
    String? passwordToLinkIfRequired,
  }) async {
    if (!_google.supportsAuthenticate()) {
      throw PlatformException(code: 'platform-error');
    }

    GoogleSignInAccount? googleUser;

    try {
      googleUser = await _google.authenticate();
    } catch (e) {
      throw FirebaseAuthException(code: 'google-auth-failed');
    }

    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    try {
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code != 'account-exists-with-different-credential') rethrow;

      final email = googleUser.email;

      if (passwordToLinkIfRequired == null ||
          passwordToLinkIfRequired.isEmpty) {
        throw FirebaseAuthException(
          code: 'need-password-to-link',
          message:
              'Este e-mail já possui senha. Informe a senha para vincular o Google.',
        );
      }

      try {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: passwordToLinkIfRequired,
        );

        final user = _auth.currentUser;
        if (user == null) {
          throw FirebaseAuthException(
            code: 'link-failed',
            message: 'Falha ao obter usuário para vincular.',
          );
        }

        await user.linkWithCredential(credential);
        return await _auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (linkError) {
        if (linkError.code == 'wrong-password' ||
            linkError.code == 'invalid-credential') {
          throw FirebaseAuthException(
            code: 'invalid-password-for-link',
            message: 'Senha incorreta para vinculação.',
          );
        }
        rethrow;
      }
    }
  }

  Future<void> createUserDocument(
    Map<String, dynamic> user,
    String userId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .set(user)
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOrCreateUserDocument({
    required User user,
  }) async {
    final ref = firestore.collection('users').doc(user.uid);

    final snap = await ref.get().timeout(const Duration(seconds: 8));
    if (snap.exists && snap.data() != null) {
      return snap.data()!;
    }

    final now = FieldValue.serverTimestamp();

    final payload = <String, dynamic>{
      'id': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'createdAt': now,
      'updatedAt': now,
    };

    await ref
        .set(payload, SetOptions(merge: true))
        .timeout(const Duration(seconds: 8));

    final created = await ref.get().timeout(const Duration(seconds: 8));
    if (created.data() == null) {
      throw NullUserException();
    }
    return created.data()!;
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}
