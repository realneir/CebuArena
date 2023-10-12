import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

final teamsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  final userDetails = ref.read(userDetailsProvider);
  return TeamsProvider(userDetails).fetchTeamsForOrganization();
});

class TeamsProvider {
  final UserDetailsProvider userDetailsProvider;

  TeamsProvider(this.userDetailsProvider);

  Future<Map<String, dynamic>> fetchTeamsForOrganization() async {
    try {
      final orgId = userDetailsProvider.organizationId;

      if (orgId == null) {
        throw Exception('Error: Organization ID not available');
      }

      final apiUrl =
          'http://10.0.2.2:8000/organizations/$orgId/teams/'; // Updated API URL

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch teams: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
