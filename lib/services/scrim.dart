import 'package:captsone_ui/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:captsone_ui/widgets/Scrimmage/Scrimmagedetails.dart';
import 'package:intl/intl.dart';
import 'package:captsone_ui/services/team.dart';
import 'package:provider/provider.dart';

String dropdownValue = 'MLBB';
DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
String preferences = '';
String contactDetails = '';

Future<void> createScrimmage(BuildContext context) async {
  final url =
      'http://127.0.0.1:8000/create_scrim/'; // Replace with your Django backend URL

  final provider = Provider.of<UserDetailsProvider>(context, listen: false);
  bool isManager = provider.isManager;

  if (!isManager) {
    print('You are not authorized to create a scrimmage.');
    return;
  }

  final response = await http.post(
    Uri.parse(url),
    body: {
      'game': dropdownValue,
      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
      'time': selectedTime.format(context),
      'preferences': preferences,
      'contact': contactDetails,
    },
  );

  if (response.statusCode == 201) {
    final scrimmageDetails = jsonDecode(response.body);
    final String scrimmageId =
        scrimmageDetails['scrim_id']; // Get the scrimmage ID from the response

    // Handle the scrimmage details as desired
    print(scrimmageDetails);
    print(scrimmageId);

    Navigator.pop(context);
  } else {
    print('Failed to create scrimmage. Error: ${response.statusCode}');
  }
}
