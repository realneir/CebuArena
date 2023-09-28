import 'dart:convert';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final organizationInfoProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final userDetails = ref.read(userDetailsProvider);
  final organizationInfo = GetOrganizationInfo(userDetails);
  return organizationInfo.fetchOrganizationInfo();
});

class OrganizationInfoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final organizationInfoAsyncValue = ref.watch(organizationInfoProvider);

      return Theme(
        // ... Existing Theme Data
        data: ThemeData(
            // ... Other Theme Data
            ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Organization Info'),
          ),
          body: organizationInfoAsyncValue.when(
            data: (data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Is Approved: ${data['is_approved']}'),
                  Text('Organization Description: ${data['org_description']}'),
                  Text('Organization Name: ${data['org_name']}'),
                  Text('Owner First Name: ${data['owner']['firstname']}'),
                  Text('Owner Last Name: ${data['owner']['lastname']}'),
                  // ... Add other fields as needed ...
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text('Error: $error'),
          ),
        ),
      );
    });
  }
}

class GetOrganizationInfo {
  final UserDetailsProvider userDetailsProvider;

  GetOrganizationInfo(this.userDetailsProvider);

  Future<Map<String, dynamic>> fetchOrganizationInfo() async {
    try {
      final localId = userDetailsProvider.localId;

      if (localId == null) {
        throw Exception('Error: Local ID not available');
      }

      final apiUrl =
          'http://10.0.2.2:8000/get_user_organization_info/$localId/';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('error_message')) {
          throw Exception(responseData['error_message']);
        } else {
          throw Exception('Unknown error occurred');
        }
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
