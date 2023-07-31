import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final firebaseAuthMethodsProvider = Provider<FirebaseAuthMethods>(
    (ref) => FirebaseAuthMethods(FirebaseAuth.instance));

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await UserSyncService().syncUserData(userCredential.user!.uid);
      if (!userCredential.user!.emailVerified) {
        await sendEmailVerification();
      }
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await UserSyncService().syncUserData(userCredential.user!.uid);
      await sendEmailVerification();
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
