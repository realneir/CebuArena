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
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Create Scrim',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black, // Change the color of the back button
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  value: selectedGame,
                  hint: const Text('Select a game'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGame = newValue;
                    });
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
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    contactDetails = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Contact Details',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    preferences = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Preferences',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300], // button's fill color
                    onPrimary: Colors.black, // text color
                  ),
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
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300], // button's fill color
                    onPrimary: Colors.black, // text color
                  ),
                  onPressed: () async {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: const Text('Pick Time'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
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
                          // scrim contains the details of the scrimmage that was just created.
                          // You can now display this scrimmage on your scrimmages page.
                        });
                      }).catchError((error) {
                        print('Failed to create scrimmage: $error');
                      });
                    } else {
                      print('Please fill in all the details');
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // button's fill color
                    onPrimary: Colors.white, // text color
                  ),
                  child: const Text('Create Scrimmage'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
