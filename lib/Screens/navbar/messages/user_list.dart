import 'package:captsone_ui/Screens/navbar/messages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> getCurrentUserId() async {
  return FirebaseAuth.instance.currentUser?.uid;
}

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<dynamic> _users = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId().then((userId) {
      setState(() {
        currentUserId = userId;
      });
    });
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/all_users/'));
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final List<dynamic> usersData = json.decode(responseBody);
          String? currentUserId =
              await getCurrentUserId(); // Fetch current user id
          if (currentUserId != null) {
            usersData.removeWhere((user) =>
                user['id'] == currentUserId); // Filter out current user
          }
          setState(() {
            _users = usersData;
          });
        }
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToChatPage(String userId, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(userId: userId, username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<String?>(
        future: getCurrentUserId(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String? currentUserId = snapshot.data;
            if (currentUserId == null) {
              return Center(child: Text('User not logged in'));
            }
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final userData = _users[index];

                if (userData['id'] == currentUserId) {
                  return Container(); // Do not display the current user
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      userData['username']?[0].toUpperCase() ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    userData['username'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    userData['email'] ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _navigateToChatPage(
                        userData['id'] ?? '', userData['username'] ?? '');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
