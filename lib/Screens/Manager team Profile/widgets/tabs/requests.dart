import 'dart:convert';

import 'package:captsone_ui/services/teamsProvider/team.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

Widget buildPendingRequestsSection(
    BuildContext context, WidgetRef ref, Map<String, dynamic>? teamData) {
  final dynamic pendingRequestsData = teamData?['pending_requests'];
  final List<Map<String, dynamic>> pendingRequests =
      pendingRequestsData is List ? List.from(pendingRequestsData) : [];
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SingleChildScrollView(
      child: Column(
        children: [
          for (final request in pendingRequests)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/Slider1.jpg'),
                      radius: 25,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['username'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Email: ${request['email']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        respondToRequest(
                            request['team_id'], request['localId'], true, ref);
                      },
                      icon: Icon(Icons.check),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        respondToRequest(
                            request['team_id'], request['localId'], false, ref);
                      },
                      icon: Icon(Icons.clear),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Future<void> respondToRequest(
  String? teamId,
  String? localId,
  bool accept,
  WidgetRef ref,
) async {
  final managerId = ref.watch(userDetailsProvider).localId;
  final url = Uri.parse('http://10.0.2.2:8000/respond_to_request/');

  print(teamId);
  print(localId);
  print(managerId);

  if (teamId == null || localId == null || managerId == null) {
    print('Invalid parameters');
    return;
  }

  try {
    final response = await http.post(
      url,
      body: {
        'team_id': teamId,
        'localId': localId,
        'accept': accept.toString(),
        'manager_id': managerId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData['message']); // Process the response data as needed
      ref.read(teamProvider.notifier).fetchTeams();
    } else {
      print('Failed to process the request: ${response.body}');
    }
  } catch (e) {
    print('Failed to connect to the server: $e');
  }
}
