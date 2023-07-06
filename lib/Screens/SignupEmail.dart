import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:captsone_ui/widgets/SignupEmail/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailPasswordSignup extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String?> signUpUser() async {
    String? result = await signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
    );

    if (result == null) {
      // Registration successful
      // Add your desired navigation logic here
    } else {
      // Registration failed
      // Handle the failure, e.g., display an error message
      print('Registration failed: $result');
    }
  }

  Future<String?> signUpWithEmail(
      {required String email, required String password}) async {
    String url =
        'http://127.0.0.1:8000/register/'; // Replace with your API endpoint URL

    // Create a JSON object with the signup data
    Map<String, String> data = {
      'username': email,
      'password': password,
      'confirm_password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Registration successful
        return null;
      } else {
        // Registration failed
        var responseBody = json.decode(response.body);
        var errorMessage = responseBody['error_message'];
        return errorMessage;
      }
    } catch (error) {
      // Handle the error
      print('Error occurred while registering: $error');
      return 'An error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController confirmController = TextEditingController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Sign Up",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: confirmController,
              hintText: 'Confirm your password',
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == confirmController.text) {
                signUpUser();
              } else {
                showSnackBar(context, "Passwords do not match.");
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
