// ignore_for_file: depend_on_referenced_packages

import 'package:captsone_ui/Screens/authentication/signup_screen.dart';
import 'package:captsone_ui/Screens/navbar/homepage.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/services/authenticationProvider/firebase_auth_methods.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmailPasswordLogin extends HookConsumerWidget {
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    void handleLogin(BuildContext context) async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showSnackBar(context, 'Please enter username and password');
        return;
      }

      String email =
          emailController.text.trim(); // Trim any leading/trailing spaces

      print("Email: $email"); // Check if the email is correct

      final authMethods = ref.read(firebaseAuthMethodsProvider);
      final userDetails = ref.read(userDetailsProvider);

      // Log in with Firebase first
      UserCredential? userCredential;
      String? firebaseErrorMessage;
      try {
        userCredential = await authMethods.loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
        );
      } catch (e) {
        print('Firebase Login Error: $e');
        firebaseErrorMessage = e.toString(); // Capture the error message
      }

      // If Firebase login was unsuccessful, show the error message
      if (userCredential == null) {
        showSnackBar(
            context, firebaseErrorMessage ?? 'Failed to log in with Firebase');
        return;
      }

      // If Firebase login was successful, log in with your API
      String? apiErrorMessage = await userDetails.loginWithEmailAPI(
        email: userCredential.user?.email ?? '',
        password: passwordController.text,
      );

      if (apiErrorMessage == null) {
        // User details have been updated in the UserDetailsProvider
        // Continue with your navigation or other logic here
        if (userDetails.username != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        } else {
          showSnackBar(context, 'Failed to fetch user details');
        }
      } else {
        showSnackBar(context, apiErrorMessage);
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenWidth * 0.05),
                  Image.asset(
                    'assets/blackLogo.png',
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome to CebuArena',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(),
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () => handleLogin(context),
                    child: Text('Sign in'),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailPasswordSignup(),
                            ),
                          );
                        },
                        child: Text('Register now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
