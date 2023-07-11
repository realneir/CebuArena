import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRegis {
  static const String API_ENDPOINT = "http://127.0.0.1:8000/register/";

  Future<String> signUpWithEmail(
      String firstname,
      String lastname,
      String username,
      String email,
      String password,
      String confirmPassword) async {
    final response = await http.post(
      Uri.parse("$API_ENDPOINT/register/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return 'Registration successful';
    } else {
      throw Exception('Failed to register');
    }
  }
}

class UserDetailsProvider extends ChangeNotifier {
  String? _username;
  String? _firstname;
  String? _lastname;
  String? _localId;

  static final provider = ChangeNotifierProvider<UserDetailsProvider>((ref) {
    return UserDetailsProvider();
  });

  String? get username => _username;
  String? get firstname => _firstname;
  String? get lastname => _lastname;

  Future<void> fetchUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user!.getIdToken();

      // Fetch the user details from the API
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/current_user/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _username = data['username'];
        _firstname = data['firstname'];
        _lastname = data['lastname'];

        notifyListeners();
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (error) {
      print('Error occurred while fetching user details: $error');
      throw Exception('An error occurred while fetching user details');
    }
  }

  Future<String?> loginWithEmailAPI(
      {required String username, required String password}) async {
    String url = 'http://127.0.0.1:8000/login/';

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
        final responseData = json.decode(response.body);
        _username = responseData['username'];
        _localId = responseData['localId'];
        _firstname = responseData['firstname'];
        _lastname = responseData['lastname'];

        print('Local ID: $_localId');
        print('Username: $_username');
        print('First Name: $_firstname');
        print('Last Name: $_lastname');

        notifyListeners();
        return _localId;
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
}

class AuthProvider {
  static final provider = ChangeNotifierProvider<UserDetailsProvider>((ref) {
    return UserDetailsProvider();
  });
}
