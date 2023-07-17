import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  //email
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
      _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      await Provider.of<UserDetailsProvider>(context, listen: false)
          .fetchUserDetails();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Email Verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'NA SEND NA ANG EMAIL VERIFICATION!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      // Send a POST request to the logout endpoint
      await http.post(Uri.parse('http://172.30.12.51:8000/logout/'));
      // await _auth.signOut();
      // Perform any additional logout logic in your frontend
    } catch (e) {
      showSnackBar(context, 'Logout failed'); // Display an error message
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Send a POST request to the delete account endpoint
      await http.post(Uri.parse('http://172.30.12.51:8000/delete_account/'),
          headers: {
            'Authorization':
                'Bearer your_token', // Replace 'your_token' with the user's token
          });
      // Perform any additional logic in your frontend, such as navigating to a different screen
    } catch (e) {
      showSnackBar(
          context, 'Account deletion failed'); // Display an error message
    }
  }
}
