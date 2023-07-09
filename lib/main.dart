import 'package:captsone_ui/Screens/Homescreen.dart';
import 'package:captsone_ui/Screens/LoginScreen.dart';
import 'package:captsone_ui/Screens/SignupEmail.dart';
import 'package:captsone_ui/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:captsone_ui/screens/Homepage.dart';
import 'package:captsone_ui/services/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<UserDetailsProvider>(
          create: (_) => UserDetailsProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: HomeScreen(),
    );
  }
}
