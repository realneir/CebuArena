import 'dart:collection';

import 'package:captsone_ui/services/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

final scrimIdProvider = StateProvider<String?>((ref) => null);

final createScrimProvider =
    FutureProvider.family<Map<String, dynamic>, CreateScrimParams>(
  (ref, params) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/create_scrim/'),
    );

    request.fields['game'] = params.dropdownValue;
    request.fields['date'] =
        DateFormat('yyyy-MM-dd').format(params.selectedDate);
    request.fields['time'] = formatTimeOfDay(params.selectedTime);
    request.fields['preferences'] = params.preferences;
    request.fields['contact'] = params.contactDetails;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      // Decode the response body which contains the scrim ID
      var responseBody = jsonDecode(response.body);
      var scrimId = responseBody['scrim_id'];

      if (scrimId == null || scrimId == "") {
        throw Exception('Scrim ID is missing in the response');
      }

      // Now use this scrim ID to fetch the scrim details
      final scrimmageResponse = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/get_scrim_details/${params.dropdownValue}/$scrimId'),
      );

      if (scrimmageResponse.statusCode == 200) {
        var completeScrimmageData = jsonDecode(scrimmageResponse.body);
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

Future<List<Map<String, dynamic>>> getAllScrimsByGame(String game) async {
  print('Fetching scrims for game: $game'); // Add this line
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/get_all_scrims/$game/'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      final scrims = data.entries.map<Map<String, dynamic>>(
        (entry) {
          final scrimId = entry.key;
          if (entry.value is Map<String, dynamic>) {
            final scrimDetails = entry.value as Map<String, dynamic>;
            return {
              'id': scrimId,
              ...scrimDetails, // Include all scrim details in the result
            };
          } else {
            throw Exception('Invalid scrim details for scrim with ID $scrimId');
          }
        },
      ).toList();
      return scrims;
    } else {
      throw Exception('Invalid response data: $data');
    }
  } else {
    print('Server error: ${response.body}'); // Add this line
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
