import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Roles reconocidos por la app
enum UserRole { student, lecturer }

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Web client ID requerido para Flutter web
    clientId: kIsWeb
        ? '538559006995-nn1d7e2moo2l7un5t3j6ubifkbnd14do.apps.googleusercontent.com'
        : null,
  );

  User? get currentUser => _auth.currentUser;

  /// true si la plataforma soporta Google Sign-In
  static bool get supportsGoogle =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  /// Devuelve el rol según el email.
  static UserRole roleFor(String email) {
    if (email.toLowerCase().contains('lecturer')) return UserRole.lecturer;
    return UserRole.student;
  }

  /// Login con email + contraseña
  Future<({User user, UserRole role})> signIn(
      String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return (user: cred.user!, role: roleFor(email));
  }

  /// Registro con email + contraseña
  Future<({User user, UserRole role})> register(
      String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return (user: cred.user!, role: roleFor(email));
  }

  /// Login con Google — funciona en Web, Android, iOS, macOS
  Future<({User user, UserRole role})> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    return (user: cred.user!, role: roleFor(cred.user!.email ?? ''));
  }

  Future<void> signOut() async {
    if (supportsGoogle) await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
