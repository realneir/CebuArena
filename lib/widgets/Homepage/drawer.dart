import 'package:captsone_ui/Screens/LoginScreen.dart';
import 'package:captsone_ui/Screens/Profilescreen.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/services/firebase_auth_methods.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // ... Rest of the code ...

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackBar(context, 'Signed out successfully.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
      showSnackBar(context, 'Account deleted successfully.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}

class SidebarMenu extends StatelessWidget {
  final String username;

  const SidebarMenu({required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.yellow.withOpacity(0.7),
                  Colors.green.withOpacity(0.7)
                ],
              ),
            ),
            accountName: Text(username, style: TextStyle(color: Colors.white)),
            accountEmail: Text(
              'Followers: 10 | Following: 20',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.blue),
            title: Text('Profile', style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.green),
            title: Text('Get Verified', style: TextStyle(color: Colors.green)),
            onTap: () {
              // Add your Get Verified page navigation logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('Settings', style: TextStyle(color: Colors.orange)),
            onTap: () {
              // Add your Settings page navigation logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<FirebaseAuthMethods>().signOut(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<FirebaseAuthMethods>().deleteAccount(context);
            },
          ),
        ],
      ),
    );
  }
}
