import 'dart:io';
import 'package:captsone_ui/Screens/authentication/login_screen.dart';
import 'package:captsone_ui/Screens/splash_screen/Lottie.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyC3wDbB5HBRt2GppgpZcWT3hu8EzJuCKMo",
            appId: "1:252862784800:android:ee9836ea1c5c3ceb9c6345",
            messagingSenderId: "252862784800",
            projectId: "tests-c91d0",
          ),
        )
      : await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: CoverPage(),
    );
  }
}
