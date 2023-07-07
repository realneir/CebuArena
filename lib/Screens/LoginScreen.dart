import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:captsone_ui/widgets/SignupEmail/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:captsone_ui/screens/Homepage.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login-email-password';
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String?> loginWithEmailAPI(
      {required String username, required String password}) async {
    String url =
        'http://127.0.0.1:8000/login/'; // Replace with your API endpoint URL

    Map<String, String> data = {
      'username': username,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Login successful
        return null;
      } else {
        // Login failed
        var responseBody = json.decode(response.body);
        var errorMessage = responseBody['error_message'];
        return errorMessage;
      }
    } catch (error) {
      // Handle the error
      print('Error occurred while logging in: $error');
      return 'An error occurred. Please try again.';
    }
  }

  void handleLogin() async {
    String? errorMessage = await loginWithEmailAPI(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (errorMessage == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Homepage()), // Replace HomePage() with your actual home screen widget
      );
    } else {
      // Login failed
      showSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: usernameController,
              hintText: 'Enter your username',
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
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              handleLogin();
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
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
