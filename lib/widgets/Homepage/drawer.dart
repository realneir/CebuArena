// ignore_for_file: use_build_context_synchronously

import 'package:captsone_ui/Screens/sidebar/leaderboards.dart';
import 'package:captsone_ui/Screens/sidebar/profile_screen.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.grey],
              ),
            ),
            accountName: Text(
              username ?? '',
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
            accountEmail: Text(
              'Followers: 10 | Following: 20',
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              )),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                (username != null && username.isNotEmpty)
                    ? username[0].toUpperCase()
                    : '?',
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                )),
              ),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.account_circle_outlined, color: Colors.black),
            title: Text(
              'Profile',
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_outlined, color: Colors.black),
            title: Text(
              'Get Verified',
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
            ),
            onTap: () {
              //Verification logic
            },
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.leaderboard_outlined, color: Colors.black),
            title: Text(
              'Leaderboards',
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Leaderboards()),
              );
            },
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.settings_outlined,
          //       color: Colors.deepPurpleAccent),
          //   title: Text(
          //     'Settings',
          //     style: GoogleFonts.openSans(
          //         textStyle: const TextStyle(
          //       color: Colors.black,
          //       fontSize: 16,
          //     )),
          //   ),
          //   onTap: () {
          //     // Add your Settings page navigation logic here
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
              )),
            ),
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
