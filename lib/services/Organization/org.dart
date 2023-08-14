import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final createOrganizationProvider =
    Provider.autoDispose<CreateOrganization>((ref) {
  final userDetails = ref.read(userDetailsProvider);
  return CreateOrganization(userDetails);
});

class CreateOrganization {
  final UserDetailsProvider userDetailsProvider;

  CreateOrganization(this.userDetailsProvider);

  Future<String> createOrganization({
    required String orgName,
    required String orgDescription,
  }) async {
    try {
      final localId = userDetailsProvider.localId;

      if (localId == null) {
        return 'Error: Local ID not available';
      }

      const apiUrl =
          'http://192.168.1.5:8000/create_organization/'; // Replace with your actual API URL

      final response = await http.post(
        Uri.parse(apiUrl), // Parse the URL string to Uri
        headers: {
          'Content-Type': 'application/json'
        }, // Set headers if required
        body: jsonEncode({
          'localId': localId,
          'org_name': orgName,
          'org_description': orgDescription,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('message')) {
          return 'Organization creation successful';
        } else if (responseData.containsKey('error_message')) {
          return responseData['error_message'];
        } else {
          return 'Unknown error occurred';
        }
      } else {
        return 'Failed to create organization: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
