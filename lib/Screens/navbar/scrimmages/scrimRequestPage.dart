import 'dart:convert';
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
                return RequestDetailCard(request: request);
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      print('Error while fetching scrim requests: ${response.body}');
      throw Exception('Failed to load scrim requests');
    }
  }
}

class RequestDetailCard extends ConsumerWidget {
  final Map<String, dynamic> request;

  const RequestDetailCard({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/teamProfile.jpg'),
              radius: 25,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scrim ID: ${request['scrim_id']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Team: ${request['team_name']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Manager: ${request['manager_username']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Status: ${request['status']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            TextButton(
              child: const Text('Respond'),
              onPressed: () {
                // Handle responding to the request here
              },
            ),
          ],
        ),
      ),
    );
  }
}
