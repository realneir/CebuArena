import 'package:captsone_ui/Screens/Lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:captsone_ui/services/auth_provider.dart';

import 'widgets/Homepage/drawer.dart';

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
        // ChangeNotifierProvider<UserDataProvider>(
        //   create: (_) => UserDataProvider(),
        // ),
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
      home: CoverPage(),
    );
  }
}
