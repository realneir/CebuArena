import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class UserSyncService {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> syncUserData(String localId) async {
    final event = await _userRef.child(localId).once();
    final snapshot = event.snapshot;
    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      final data =
          Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      await userCollection.doc(localId).set({
        'firstname': data['firstname'],
        'lastname': data['lastname'],
        'username': data['username'],
        'email': data['email'], // Also syncing email
      });
    }
  }
}

class FirebaseAuthMethods extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await UserSyncService().syncUserData(_auth.currentUser!.uid);

      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await UserSyncService().syncUserData(_auth.currentUser!.uid);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      await Provider.of<UserDetailsProvider>(context, listen: false)
          .fetchUserDetails();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'NA SEND NA ANG EMAIL VERIFICATION!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
