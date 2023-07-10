import 'package:captsone_ui/Screens/SignupEmail.dart';
import 'package:captsone_ui/screens/Homepage.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailPasswordLogin extends StatefulWidget {
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    UserDetailsProvider userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);

    String? errorMessage = await userDetailsProvider.loginWithEmailAPI(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (errorMessage == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      showSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth * 0.05),

                Image.asset(
                  'blackLogo.png',
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                ),

                const SizedBox(height: 50),
                Text(
                  'Welcome to CebuArena',
                  style: TextStyle(
                    color: Colors.black, // changing text color to black
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true, // added for a fill color
                    fillColor: Colors.grey[200], // light grey fill color
                    border: OutlineInputBorder(), // added border
                  ),
                  obscureText: false,
                ),

                const SizedBox(height: 20), // added space between form fields

                // password textfield
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // changing button color to black
                  ),
                  onPressed: handleLogin,
                  child: Text('Sign in'),
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dont have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailPasswordSignup()),
                        );
                      },
                      child: Text('Register now'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
