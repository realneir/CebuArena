import 'dart:math';

import 'package:captsone_ui/Screens/authentication/signupScreen.dart';
import 'package:captsone_ui/Screens/navbar/homepage.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:captsone_ui/services/authenticationProvider/firebaseAuthMethods.dart';
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
    final isLoading = useState(false);

    final animationController = useAnimationController(
      duration: const Duration(seconds: 5),
    );

    final animation = useAnimation(
      Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear),
      ),
    );

     animationController.repeat();

    void handleLogin(BuildContext context) async {
      isLoading.value = true; // Start loading

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showSnackBar(context, 'Please enter email and password');
        isLoading.value = false; // End loading if failed
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
        isLoading.value = false; // End loading if failed
        return;
      }

      // If Firebase login was successful, log in with your API
      String? apiErrorMessage = await userDetails.loginWithEmailAPI(
        email: userCredential.user?.email ?? '',
        password: passwordController.text,
      );

      isLoading.value = false; // End loading

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
      backgroundColor: const Color(0xFF1803bf),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E1E), 
              Color(0xFF3E3E3E), 
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
               CustomPaint(
                painter: WavyPainter(animation: animationController.value),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ), // Adjust size as needed
              ),
              SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenWidth * 0.05),
                        Image.asset(
                          'assets/cebuarena.png',
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
                            hintText: 'Email',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
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
              isLoading.value
                  ? Center(
                      child: Image.network(
                        'https://media.giphy.com/media/1a88wypaZjARiv0ggy/giphy.gif',
                        width: 350,
                        height: 350,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class WavyPainter extends CustomPainter {
  final double animation;

  WavyPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Calculating the phase shift using animation value for each wave
    final phaseShift = animation * 2 * pi;

    // Top wave
    final pathTop = Path()
      ..moveTo(0, 10 * sin(phaseShift))
      ..quadraticBezierTo(size.width / 4, 10 * sin(phaseShift + pi / 2), size.width / 2, 10 * sin(phaseShift))
      ..quadraticBezierTo(size.width * 3 / 4, 10 * sin(phaseShift - pi / 2), size.width, 10 * sin(phaseShift))
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(pathTop, paint);

    // Bottom wave (mirroring the top wave)
    final pathBottom = Path()
      ..moveTo(0, size.height - 10 * sin(phaseShift))
      ..quadraticBezierTo(size.width / 4, size.height - 10 * sin(phaseShift + pi / 2), size.width / 2, size.height - 10 * sin(phaseShift))
      ..quadraticBezierTo(size.width * 3 / 4, size.height - 10 * sin(phaseShift - pi / 2), size.width, size.height - 10 * sin(phaseShift))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathBottom, paint);

    // Left wave
    final pathLeft = Path()
      ..moveTo(10 * sin(phaseShift), 0)
      ..quadraticBezierTo(10 * sin(phaseShift + pi / 2), size.height / 4, 10 * sin(phaseShift), size.height / 2)
      ..quadraticBezierTo(10 * sin(phaseShift - pi / 2), size.height * 3 / 4, 10 * sin(phaseShift), size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(pathLeft, paint);

    // Right wave (mirroring the left wave)
    final pathRight = Path()
      ..moveTo(size.width - 10 * sin(phaseShift), 0)
      ..quadraticBezierTo(size.width - 10 * sin(phaseShift + pi / 2), size.height / 4, size.width - 10 * sin(phaseShift), size.height / 2)
      ..quadraticBezierTo(size.width - 10 * sin(phaseShift - pi / 2), size.height * 3 / 4, size.width - 10 * sin(phaseShift), size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(pathRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}