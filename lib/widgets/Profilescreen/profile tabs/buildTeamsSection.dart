import 'dart:io';
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
                        "DOTA 2",
                        "CODM",
                        "Valorant",
                        "League of Legends",
                        "Wildrift"
                      ]; // List of games

                      File? logo;

                      Future<void> _pickLogo() async {
                        final status = await Permission.storage.request();
                        if (status.isGranted) {
                          final pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedImage != null) {
                            logo = File(pickedImage.path);
                          }
                        } else {
                          // Handle permission denied
                        }
                      }

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
                                ElevatedButton(
                                  onPressed: () async {
                                    await _pickLogo();
                                    setState(() {});
                                  },
                                  child: const Text('Pick Logo'),
                                ),
                                if (logo != null) Image.file(logo!),
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
                                        selectedGame!,
                                        logo, // Pass the logo file
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

      return Column(
        children: [
          for (final teamData in teamList)
            Column(
              children: [
                Text(
                  teamData['team_name'] ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      (teamData['members'] as List<dynamic>?)?.length ?? 0,
                  itemBuilder: (context, index) {
                    final member = (teamData['members']
                        as List<dynamic>?)?[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text('${member['username']}'),
                      subtitle: Text(
                        'Firstname: ${member['firstname']} Lastname: ${member['lastname']}',
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      );
    });
  }
}
