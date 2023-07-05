import 'package:captsone_ui/Screens/Profilescreen.dart';
import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final String username;

  SidebarMenu({required this.username});

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
                ], // You can adjust the colors and opacity here
              ),
            ),
            accountName: Text(username, style: TextStyle(color: Colors.white)),
            accountEmail: Text(
              'Followers: 10 | Following: 20', // Replace with your real followers and following data
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                username[0].toUpperCase(),
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
              // Add your Logout logic here
            },
          ),
        ],
      ),
    );
  }
}
