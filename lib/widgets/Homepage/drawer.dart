import 'package:captsone_ui/Screens/sidebar/leaderboards.dart';
import 'package:captsone_ui/Screens/sidebar/profile_screen.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends ConsumerWidget {
  final String? username;

  const SidebarMenu({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final String? username = userDetails.username;

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
                  Colors.black.withOpacity(0.7),
                  Colors.black12.withOpacity(0.7)
                ],
              ),
            ),
            accountName:
                Text(username ?? '', style: TextStyle(color: Colors.white)),
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
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.black),
            title: Text('Profile', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.black),
            title: Text('Get Verified', style: TextStyle(color: Colors.black)),
            onTap: () {
              // Add your Get Verified page navigation logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.leaderboard, color: Colors.black),
            title: Text('Leaderboards', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Leaderboards()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text('Settings', style: TextStyle(color: Colors.black)),
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
              // ref.read(authProvider).deleteAccount();
            },
          ),
        ],
      ),
    );
  }
}
