// ignore_for_file: use_build_context_synchronously

import 'package:captsone_ui/Screens/sidebar/leaderboards.dart';
import 'package:captsone_ui/Screens/sidebar/profile_screen.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/services/authenticationProvider/firebase_auth_methods.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarMenu extends ConsumerWidget {
  final String? username;

  const SidebarMenu({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final String? username = userDetails.username;

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black12.withOpacity(0.7)
                ],
              ),
            ),
            accountName: Text(username ?? '',
                style: const TextStyle(color: Colors.white)),
            accountEmail: Text(
              'Followers: 10 | Following: 20',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                (username != null && username.isNotEmpty)
                    ? username[0].toUpperCase()
                    : '?',
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.black),
            title: const Text('Profile', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user, color: Colors.black),
            title: const Text('Get Verified',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              // Add your Get Verified page navigation logic here
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.leaderboard, color: Colors.black),
            title: const Text('Leaderboards',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Leaderboards()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title:
                const Text('Settings', style: TextStyle(color: Colors.black)),
            onTap: () {
              // Add your Settings page navigation logic here
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleSignOut(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
