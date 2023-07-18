import 'dart:io';
import 'package:captsone_ui/Screens/Manager%20team%20Profile/teamProfile.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/services/Teams%20provider/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TeamsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final isManager = userDetails.isManager;

    return Consumer(builder: (context, ref, _) {
      final teamList = ref.watch(teamProvider.notifier);

      // Check if the teamList is empty
      if (teamList.isEmpty) {
        if (!isManager) {
          return Column(
            children: [
              Text('No team data available.'),
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String? teamName = '';
                      String? selectedGame;
                      List<String> games = [
                        "MLBB",
                        "DOTA2",
                        "CODM",
                        "VALORANT",
                        "LOL",
                        "WILDRIFT"
                      ]; // List of games

                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: const Text("Create a team"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    teamName = value;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Enter team name',
                                  ),
                                ),
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
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  // Check if team name, game, and managerId are not null
                                  final managerId =
                                      ref.read(userDetailsProvider).localId;
                                  final String game =
                                      ""; // Add your game variable here

                                  if (teamName != null &&
                                      teamName!.isNotEmpty &&
                                      selectedGame != null &&
                                      managerId != null) {
                                    ref
                                        .read(createTeamProvider(
                                      CreateTeamParams(
                                        teamName!,
                                        game,
                                        selectedGame!, // Pass the logo file
                                      ),
                                    ))
                                        .when(
                                      data: (newTeamData) {
                                        // The team was created successfully
                                        print("Team was created: $newTeamData");
                                        ref
                                            .read(teamProvider.notifier)
                                            .fetchTeams();
                                      },
                                      loading: () {
                                        // Optional loading state handling
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Creating team...'),
                                              content:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        // There was an error creating the team
                                        print("Error creating team: $error");
                                      },
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    // Show an error if the team name, game, or managerId is null
                                    print(
                                        "Please enter a team name, select a game, and ensure the user is logged in.");
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.black,
              ),
            ],
          );
        } else {
          return Text('No team data available.');
        }
      }

      return Padding(
        padding: const EdgeInsets.all(10), // Set the desired top padding value
        child: Column(
          children: [
            for (final teamData in teamList)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamProfileScreen(),
                    ),
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set your desired background color
                    border: Border.all(
                      color: Colors.black, // Set your desired border color
                      width: 1.0, // Set your desired border width
                    ),
                    borderRadius: BorderRadius.circular(
                        10), // Set your desired border radius
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/Slider1.jpg'), // Set the path to your team logo image
                            radius: 25,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teamData['team_name'] ?? '',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Manager: ${teamData['manager_username'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
