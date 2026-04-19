import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../dataconnect_generated/generated.dart';

enum UserRole { student, lecturer }

class AppUser {
  final String dbId;   // PostgreSQL UUID
  final String uid;    // Firebase Auth UID
  final String email;
  final String name;
  final UserRole role;

  const AppUser({
    required this.dbId,
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });
}

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '538559006995-nn1d7e2moo2l7un5t3j6ubifkbnd14do.apps.googleusercontent.com'
        : null,
  );

  AppUser? currentAppUser;

  User? get currentUser => _auth.currentUser;

  static bool get supportsGoogle =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  static UserRole _roleFor(String email) {
    if (email.toLowerCase().contains('lecturer')) return UserRole.lecturer;
    return UserRole.student;
  }

  // Fetch or create the DB user profile after Firebase Auth login
  Future<AppUser> _loadOrCreateDbUser(User firebaseUser) async {
    final connector = ExampleConnector.instance;
    final result = await connector
        .getUser(uid: firebaseUser.uid)
        .execute();

    if (result.data.users.isNotEmpty) {
      final u = result.data.users.first;
      return AppUser(
        dbId: u.id,
        uid: u.uid,
        email: u.email,
        name: u.name,
        role: u.role == 'lecturer' ? UserRole.lecturer : UserRole.student,
      );
    }

    // User not in DB yet — create it
    final role = _roleFor(firebaseUser.email ?? '');
    await connector.createUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? firebaseUser.email ?? 'User',
      role: role == UserRole.lecturer ? 'lecturer' : 'student',
    ).execute();

    // Fetch again to get the generated UUID
    final created = await connector
        .getUser(uid: firebaseUser.uid)
        .execute();

    final u = created.data.users.first;
    return AppUser(
      dbId: u.id,
      uid: u.uid,
      email: u.email,
      name: u.name,
      role: role,
    );
  }

  Future<AppUser> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    currentAppUser = await _loadOrCreateDbUser(cred.user!);
    return currentAppUser!;
  }

  Future<AppUser> register(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    currentAppUser = await _loadOrCreateDbUser(cred.user!);
    return currentAppUser!;
  }

  Future<AppUser> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await _auth.signInWithCredential(credential);
    currentAppUser = await _loadOrCreateDbUser(cred.user!);
    return currentAppUser!;
  }

  Future<void> signOut() async {
    currentAppUser = null;
    if (supportsGoogle) await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
