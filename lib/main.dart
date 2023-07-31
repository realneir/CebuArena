import 'dart:io';
import 'package:captsone_ui/Screens/authentication/loginScreen.dart';
import 'package:captsone_ui/Screens/splash_screen/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBtnQ4ekqXybSYuvPW2h_PaDCopMdKp8jM",
            appId: "1:44015113924:web:e687208c82863db5d15b91",
            messagingSenderId: "44015113924",
            projectId: "cebuarena-database",
          ),
        )
      : await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => const CoverPage(),
        '/login': (context) => const EmailPasswordLogin(),
      },
    );
  }
}
