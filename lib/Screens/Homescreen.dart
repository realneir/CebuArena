import 'package:captsone_ui/Screens/Phonescreen.dart';
import 'package:flutter/material.dart';
import 'package:captsone_ui/Screens/LoginScreen.dart';
import 'package:captsone_ui/Screens/SignupEmail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Navigate to Email Login Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailPasswordLogin(),
                    ),
                  );
                },
                child: const Text('Login using Email'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  // Navigate to Phone Login Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneScreen(),
                    ),
                  );
                },
                child: const Text('Login using Phone'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  // Navigate to Email Signup Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailPasswordSignup(),
                    ),
                  );
                },
                child: const Text('Signup using Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
