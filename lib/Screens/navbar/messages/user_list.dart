import 'package:captsone_ui/Screens/navbar/messages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/all_users/'));
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody != null && responseBody.isNotEmpty) {
          final List<dynamic> usersData = json.decode(responseBody);
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
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final userData = _users[index];
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
      ),
    );
  }
}
