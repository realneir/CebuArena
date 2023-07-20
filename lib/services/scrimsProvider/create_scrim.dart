import 'dart:collection';

import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

final scrimIdProvider = StateProvider<String?>((ref) => null);

final createScrimProvider =
    FutureProvider.family<Map<String, dynamic>, CreateScrimParams>(
  (ref, params) async {
    final url = Uri.parse('http://10.0.2.2:8000/create_scrim/');

    final response = await http.post(
      url,
      body: {
        'game': params.dropdownValue,
        'date': DateFormat('yyyy-MM-dd').format(params.selectedDate),
        'time': formatTimeOfDay(params.selectedTime),
        'preferences': params.preferences,
        'contact': params.contactDetails,
      },
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      final scrimId = responseBody['scrim_id'];

      if (scrimId == null || scrimId == "") {
        throw Exception('Scrim ID is missing in the response');
      }

      final scrimmageResponse = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/get_scrim_details/${params.dropdownValue}/$scrimId'),
      );

      if (scrimmageResponse.statusCode == 200) {
        final completeScrimmageData = jsonDecode(scrimmageResponse.body);
        return completeScrimmageData;
      } else {
        throw Exception(
            'Failed to fetch scrimmage info: ${scrimmageResponse.body}');
      }
    } else {
      throw Exception('Failed to create scrimmage: ${response.body}');
    }
  },
);

class CreateScrimParams {
  final String dropdownValue;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String preferences;
  final String contactDetails;

  CreateScrimParams(
    this.dropdownValue,
    this.selectedDate,
    this.selectedTime,
    this.preferences,
    this.contactDetails,
  );
}

Future<List<Map<String, dynamic>>> getAllScrimsByGame(
    String game, WidgetRef ref) async {
  print('Fetching scrims for game: $game');
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/get_all_scrims/$game/'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      final List<Map<String, dynamic>> scrims = [];
      final userDetails = ref.watch(userDetailsProvider);
      final managerId = userDetails.localId;

      await Future.forEach(data.entries, (entry) async {
        final scrimId = entry.key;
        if (entry.value is Map<String, dynamic>) {
          final scrimDetails = entry.value as Map<String, dynamic>;

          // Fetch the team name based on the manager_id from the scrimmage details
          final teamResponse = await http.get(
            Uri.parse('http://10.0.2.2:8000/get_team_info/$managerId/'),
          );

          final teamData = jsonDecode(teamResponse.body);
          final teamName = teamData['team_name'];

          scrims.add({
            'id': scrimId,
            'team_name': teamName,
            ...scrimDetails, // Include all scrimmage details in the result
          });
        } else {
          throw Exception(
              'Invalid scrimmage details for scrimmage with ID $scrimId');
        }
      });

      return scrims;
    } else {
      throw Exception('Invalid response data: $data');
    }
  } else {
    print('Server error: ${response.body}');
    throw Exception(
        'Failed to fetch scrims. Server returned status code ${response.statusCode}');
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

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); //"6:00 AM"
  return format.format(dt);
}
