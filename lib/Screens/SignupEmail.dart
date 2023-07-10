import 'package:captsone_ui/Screens/LoginScreen.dart';
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
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController(); // New Username Controller

  Future<String?> signUpUser() async {
    String? result = await signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text, // Passing the username to the function
      firstname: firstnameController.text, 
      lastname: lastnameController.text, 
    );

    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailPasswordLogin()),
      );
    } else {
      // Registration failed
      // Handle the failure, e.g., display an error message
      print('Registration failed: $result');
      showSnackBar(context, 'Registration failed: $result');
    }
  }

  Future<String?> signUpWithEmail(
      {required String email,
      required String password,
      required String username,
      required String firstname,
      required String lastname

      }) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/register/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
        'confirm_password': password,
        'firstname' :firstname ,
        'lastname' :lastname,
      }),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return jsonDecode(response.body)['error_message'];
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
          const SizedBox(height: 20),
           Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: firstnameController, // New TextField for username
              hintText: 'Enter your first name',
            ),
          ),
          const SizedBox(height: 20),
           Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: lastnameController, // New TextField for username
              hintText: 'Enter your last name',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: usernameController, // New TextField for username
              hintText: 'Enter your username',
            ),
          ),
          const SizedBox(height: 20),
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
