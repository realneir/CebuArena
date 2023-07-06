import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<String?> loginWithEmailAPI({
  required String email,
  required String password,
}) async {
  String url =
      'http://127.0.0.1:8000/login/'; // Replace with your API endpoint URL

  Map<String, String> data = {
    'username': email,
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
