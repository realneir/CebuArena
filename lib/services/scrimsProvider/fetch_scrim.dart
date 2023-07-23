import 'dart:convert';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

Future<String?> fetchTeamName(String managerId) async {
  final teamResponse = await http.get(
    Uri.parse('http://10.0.2.2:8000/get_team_info/$managerId/'),
  );

  if (teamResponse.statusCode == 200) {
    final teamData = jsonDecode(teamResponse.body);
    if (teamData.containsKey('team_name')) {
      return teamData['team_name'] as String?;
    }
  }
  return null;
}

Future<List<Map<String, dynamic>>> getAllScrimsByGame(
    String game, WidgetRef ref) async {
  print('Fetching scrims for game: $game');
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/get_all_scrims/$game/'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data is List<dynamic>) {
      final List<Map<String, dynamic>> scrims = [];
      final userDetails = ref.watch(userDetailsProvider);
      final managerId = userDetails.localId;
      final managerUsername = userDetails.username;

      print('ManagerId: $managerId');

      for (final entry in data) {
        if (entry is Map<String, dynamic>) {
          final scrimId = entry.keys.first;
          final scrimDetails = entry.values.first;
          final scrimManagerId = scrimDetails['manager_id'];
          print('ScrimManagerId: $scrimManagerId');
          // Fetch the team name based on the manager_id from the scrimmage details
          final teamResponse = await http.get(
            Uri.parse('http://10.0.2.2:8000/get_team_info/$scrimManagerId/'),
          );

          print('TeamResponse: ${teamResponse.body}');
          final teamData = jsonDecode(teamResponse.body);
          print('Team data: $teamData');

          String? teamName;
          if (teamData.containsKey('team_name')) {
            teamName = teamData['team_name'];
          }
          print('Team name check: $teamName');

          scrims.add({
            'manager_id': scrimManagerId,
            'id': scrimId,
            'team_name': teamName,
            'manager_username': managerUsername ?? '',
            ...scrimDetails,
          });
        } else {
          print('Invalid scrimmage details for entry: $entry');
        }
      }

      return scrims;
    } else {
      print('Invalid response data: $data');
      return [];
    }
  } else {
    print('Server error: ${response.body}');
    return [];
  }
}

Future<Map<String, dynamic>> getScrimDetails(
    String game, String scrimId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/get_scrim_details/$game/$scrimId/'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception(
        'Failed to fetch scrim details. Server returned status code ${response.statusCode}');
  }
}

final getScrimDetailsProvider =
    FutureProvider.family<Map<String, dynamic>, ScrimDetailsParams>(
        (ref, params) => getScrimDetails(params.game, params.scrimId));

class ScrimDetailsParams {
  final String game;
  final String scrimId;

  ScrimDetailsParams(this.game, this.scrimId);
}
