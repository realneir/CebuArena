import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/services/scrimsProvider/create_scrim.dart';
import 'package:captsone_ui/services/scrimsProvider/fetch_scrim.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Scrimmagedetails extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? selectedGame;
    final List<String> games = [
      "MLBB",
      "DOTA2",
      "CODM",
      "VALORANT",
      "LOL",
      "WILDRIFT"
    ];
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? preferences;
    String? contactDetails;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue[800],
            elevation: 0,
            title: Text(
              'Create Scrim',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedGame,
                      hint: Text('Select a game'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGame = newValue;
                        });
                      },
                      items:
                          games.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    contactDetails = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Contact Details',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    preferences = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Preferences',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[800]),
                  onPressed: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                  },
                  child: Text('Pick Date'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[800]),
                  onPressed: () async {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: Text('Pick Time'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[800]),
                  onPressed: () {
                    if (selectedGame != null &&
                        contactDetails != null &&
                        preferences != null &&
                        selectedDate != null &&
                        selectedTime != null) {
                      final params = CreateScrimParams(
                        selectedGame!,
                        selectedDate!,
                        selectedTime!,
                        preferences!,
                        contactDetails!,
                      );
                      ref
                          .read(createScrimProvider(params).future)
                          .then((result) {
                        print('Scrimmage created successfully: $result');
                        var scrimId =
                            result['scrim_id']; // assuming this is the format
                        getScrimDetails(selectedGame!, scrimId).then((scrim) {
                          // scrim contains the details of the scrim that was just created.
                          // You can now display this scrim on your scrimmages page.
                        });
                      }).catchError((error) {
                        print('Failed to create scrimmage: $error');
                      });
                    } else {
                      print('Please fill in all the details');
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Create Scrimmage'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
