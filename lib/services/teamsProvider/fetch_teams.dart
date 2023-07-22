import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Team {
  final String teamId;
  final String teamName;
  final Map<String, dynamic> manager;
  final List<dynamic>? members;
  final String game;

  Team({
    required this.teamId,
    required this.teamName,
    required this.manager,
    this.members,
    required this.game,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['team_id'],
      teamName: json['team_name'],
      manager: json['manager'],
      members: json['members'],
      game: json['game'],
    );
  }
}

Future<List<Team>> fetchTeams() async {
  final url = Uri.parse('http://10.0.2.2:8000/get_all_teams/');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> teamsData = responseData['teams'];
      final List<Team> teams =
          teamsData.map((json) => Team.fromJson(json)).toList();
      print(teams);
      return teams;
    } else {
      throw Exception('Failed to fetch teams');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}

final teamsProvider = FutureProvider<List<Team>>((ref) async {
  return fetchTeams();
});

class joinProvider {
  static Future<void> joinTeam(String teamId, String localId) async {
    final url = Uri.parse(
        'http://10.0.2.2:8000/join_team/'); // URL to your API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'team_id': teamId,
          'localId': localId,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully sent the request
        print('Request sent successfully.');
      } else {
        // If the server returns an unexpected status code
        throw Exception('Failed to join team');
      }
    } catch (e) {
      // There was an error sending the request
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
