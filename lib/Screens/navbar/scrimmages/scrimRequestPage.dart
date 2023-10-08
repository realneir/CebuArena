import 'dart:convert';
import 'package:captsone_ui/Screens/navbar/messages/chatPage.dart';
import 'package:captsone_ui/utils/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrimRequestPage extends ConsumerWidget {
  const ScrimRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managerId = ref.watch(userDetailsProvider).localId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrim Requests'),
        backgroundColor: Color(0xFFDAC0A3),
      ),
      body: FutureBuilder(
        future: _fetchScrimRequests(managerId!),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.isEmpty) {
            return const Text('No Scrim Requests');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var request = snapshot.data![index];
                return RequestDetailCard(
                    request: request,
                    ref: ref); // Pass the WidgetRef to the card
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchScrimRequests(
      String managerId) async {
    var url = Uri.parse('http://10.0.2.2:8000/get_scrim_requests/$managerId');
    var response = await http.get(url);

    print('Server Response: ${response.body}'); // Print the server response

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']).map((request) {
        // Assuming that the response contains scrim_id and request_id
        request['scrim_id'] = request['scrim_id']?.toString() ?? '';
        request['request_id'] = request['request_id']?.toString() ?? '';
        return request;
      }).toList();
    } else {
      print('Error while fetching scrim requests: ${response.body}');
      throw Exception('Failed to load scrim requests');
    }
  }
}

class RequestDetailCard extends ConsumerWidget {
  final Map<String, dynamic> request;
  final WidgetRef ref; // Receive the WidgetRef

  const RequestDetailCard({Key? key, required this.request, required this.ref})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/teamProfile.jpg'),
                  radius: 40,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Team: ${request['team_name']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        'Game: ${request['game']}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Manager: ${request['requesting_manager_username']}',
                        style: TextStyle(fontSize: 19),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToChat(context);
                  },
                  icon: Icon(Icons.message),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showSnackBar(context, "Declined Scrim Request");
                  },
                  child: const Text('Decline'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChat(BuildContext context) {
    print('Navigating to chat with user: ${request['requesting_manager_id']}');
    print('User\'s username: ${request['requesting_manager_username']}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userId: request['requesting_manager_id'],
          username: request['requesting_manager_username'],
        ),
      ),
    );
  }
}
