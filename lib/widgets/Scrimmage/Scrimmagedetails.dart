import 'package:captsone_ui/services/scrim.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Scrimmagedetails extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> games = [
      "MLBB",
      "DOTA 2",
      "CODM",
      "Valorant",
      "League of Legends",
      "Wildrift"
    ];
    String? dropdownValue;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? preferences;
    String? contactDetails;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Material(
              child: DropdownButton<String>(
                value: dropdownValue,
                hint: const Text('Select a game'),
                onChanged: (String? newValue) {
                  dropdownValue = newValue!;
                },
                items: games.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Material(
            child: TextField(
              onChanged: (value) {
                preferences = value;
              },
              decoration: const InputDecoration(
                labelText: 'Enter your preferences',
              ),
            ),
          ),
          Material(
            child: TextField(
              onChanged: (value) {
                contactDetails = value;
              },
              decoration: const InputDecoration(
                labelText: 'Enter your contact details',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
            },
            child: const Text('Pick Date'),
          ),
          ElevatedButton(
            onPressed: () async {
              selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
            },
            child: const Text('Pick Time'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (dropdownValue != null &&
                  selectedDate != null &&
                  selectedTime != null &&
                  preferences != null &&
                  contactDetails != null) {
                try {
                  await ref.read(scrimProvider.notifier).createScrimmage(
                      dropdownValue!,
                      selectedDate!,
                      selectedTime!,
                      preferences!,
                      contactDetails!);

                  // Scrimmage created successfully, show a dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Scrimmage Created'),
                      content: Text('Scrimmage was created successfully!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(
                                context); // Navigate back to ScrimmagesPage
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  // Error while creating scrimmage, show a dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Failed to create scrimmage: $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('Create Scrimmage'),
          ),
        ],
      ),
    );
  }
}
