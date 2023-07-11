import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/utils/showOtpDialog.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);

      // Diplay Dialog Box To accept OTP
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop(); // Remove the dialog box
        },
      );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );

              // !!! Works only on Android, iOS !!!
              await _auth.signInWithCredential(credential);
              Navigator.of(context).pop(); // Remove the dialog box
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      // Send a POST request to the logout endpoint
      await http.post(Uri.parse('http://127.0.0.1:8000/logout/'));
      // Perform any additional logout logic in your frontend
    } catch (e) {
      showSnackBar(context, 'Logout failed'); // Display an error message
    }
  }

  // DELETE ACCOUNT
  // Future<void> deleteAccount(BuildContext context) async {
  //   try {
  //     // Send a POST request to the delete account endpoint
  //     await http
  //         .post(Uri.parse('http://127.0.0.1:8000/delete_account/'), headers: {
  //       'Authorization':
  //           'Bearer your_token', // Replace 'your_token' with the user's token
  //     });
  //     // Perform any additional logic in your frontend, such as navigating to a different screen
  //   } catch (e) {
  //     showSnackBar(
  //         context, 'Account deletion failed'); // Display an error message
  //   }
  // }
}
