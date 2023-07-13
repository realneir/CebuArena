import 'package:captsone_ui/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

Future<String> createTeam(
    BuildContext context, String managerId, String teamName, String game,
    [String? selectedGame]) async {
  final provider = Provider.of<UserDetailsProvider>(context, listen: false);
  final managerId = provider.localId;

  if (managerId == null) {
    throw Exception('User is not signed in.');
  }

  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/create_team/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'manager_id': managerId,
        'team_name': teamName,
        'game': selectedGame ??
            game, // use selectedGame if it is not null, otherwise use game
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      return response.body;
    } else {
      // If the server returns an unsuccessful response code, then throw an exception.
      throw Exception('Failed to create team: ${response.body}');
    }
  } catch (e) {
    // This will handle any kind of exception: network errors, parsing errors, etc.
    throw Exception('Failed to create team: $e');
  }
}

Future<Map<String, dynamic>> fetchTeam(String managerId) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/get_team_info/$managerId/'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load team');
  }
}
