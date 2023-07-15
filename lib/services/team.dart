import 'dart:async';

import 'package:captsone_ui/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define a new Riverpod provider
Future<Map<String, dynamic>> createTeam(
    ProviderContainer container, String teamName, String game,
    [String? selectedGame]) async {
  final provider = container.read(userDetailsProvider);
  final managerId = provider.localId;

  if (managerId == null) {
    throw Exception('User is not signed in.');
  }

  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/create_team/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'manager_id': managerId,
      'team_name': teamName,
      'game': selectedGame ?? game,
    }),
  );

  if (response.statusCode == 200) {
    final teamResponse = await http
        .get(Uri.parse('http://10.0.2.2:8000/get_team_info/$managerId/'));

    if (teamResponse.statusCode == 200) {
      var completeTeamData = jsonDecode(teamResponse.body);
      return completeTeamData;
    } else {
      throw Exception('Failed to fetch team info: ${teamResponse.body}');
    }
  } else {
    throw Exception('Failed to create team: ${response.body}');
  }
}

final teamProvider =
    StateNotifierProvider<TeamNotifier, List<Map<String, dynamic>>>((ref) {
  return TeamNotifier(ref.watch(userDetailsProvider));
});

class TeamNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final UserDetailsProvider userDetails;

  TeamNotifier(this.userDetails) : super([]);

  Future<void> fetchTeams() async {
    try {
      final managerId = userDetails.localId;
      if (managerId == null) {
        print('No user logged in');
        return;
      }
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/get_team_info/$managerId/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> &&
            data.containsKey('team_name') &&
            data.containsKey('members')) {
          final teamData = {
            'team_name': data['team_name'],
            'members': data['members'],
          };
          state = [teamData];
        } else {
          print('Invalid response data: $data');
        }
      } else {
        print('Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      print('Network request failed: $e');
    }
  }
}
