import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Scrim extends StateNotifier<ScrimState> {
  Scrim() : super(ScrimState());

  Future<String?> createScrimmage(
    String dropdownValue,
    DateTime selectedDate,
    TimeOfDay selectedTime,
    String preferences,
    String contactDetails,
  ) async {
    const url = 'http://10.0.2.2:8000/create_scrim/';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'game': dropdownValue,
        'date': DateFormat('yyyy-MM-dd').format(selectedDate),
        'time': formatTimeOfDay(selectedTime),
        'preferences': preferences,
        'contact': contactDetails,
      },
    );

    if (response.statusCode == 201) {
      final scrimmageDetails = jsonDecode(response.body);
      final String scrimmageId = scrimmageDetails['scrim_id'];
      return scrimmageId;
    } else {
      throw Exception(
          'Failed to create scrimmage. Error: ${response.statusCode}');
    }
  }
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); //"6:00 AM"
  return format.format(dt);
}

class ScrimState {}

final scrimProvider =
    StateNotifierProvider<Scrim, ScrimState>((ref) => Scrim());
