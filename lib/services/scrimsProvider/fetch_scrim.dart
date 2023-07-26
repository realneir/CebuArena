import 'dart:convert';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

Future<String?> fetchTeamName(String managerId) async {
  final teamResponse = await http.get(
    Uri.parse('http://192.168.0.118:8000/get_team_info/$managerId/'),
  );

  if (teamResponse.statusCode == 200) {
    final teamData = jsonDecode(teamResponse.body);
    if (teamData.containsKey('team_name')) {
      return teamData['team_name'] as String?;
    }
  }
  return null;
}

Stream<List<Map<String, dynamic>>> getAllScrimsByGame(
    String game, WidgetRef ref) {
  return (() async* {
    print('Fetching scrims for game: $game');

    while (true) {
      final response = await http.get(
        Uri.parse('http://192.168.0.118:8000/get_all_scrims/$game/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List<dynamic>) {
          final List<Map<String, dynamic>> scrims = <Map<String, dynamic>>[];
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
              final teamName = await fetchTeamName(scrimManagerId);

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

          yield scrims;
        } else {
          print('Invalid response data: $data');
          yield <Map<String, dynamic>>[];
        }
      } else {
        print('Server error: ${response.body}');
        yield <Map<String, dynamic>>[];
      }

      // Pause for a few seconds before the next request
      await Future.delayed(Duration(seconds: 5));
    }
  })()
      .asBroadcastStream();
}

Future<Map<String, dynamic>> getScrimDetails(
    String game, String scrimId) async {
  final response = await http.get(
    Uri.parse('http://192.168.0.118:8000/get_scrim_details/$game/$scrimId/'),
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
