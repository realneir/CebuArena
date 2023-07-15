import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/services/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final isManager = userDetails.isManager;

    final teamList = ref.watch(teamProvider);

    return Column(
      children: [
        if (isManager) ...[
          if (teamList.isEmpty)
            Text('No team data available.')
          else
            Column(
              children: [
                for (final teamData in teamList)
                  Column(
                    children: [
                      Text(
                        teamData['team_name'] ?? '',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            (teamData['members'] as List<dynamic>?)?.length ??
                                0,
                        itemBuilder: (context, index) {
                          final member =
                              (teamData['members'] as List<dynamic>?)?[index]
                                  as Map<String, dynamic>;
                          return ListTile(
                            title: Text('${member['username']}'),
                            subtitle: Text(
                                'Firstname: ${member['firstname']} Lastname: ${member['lastname']}'),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
        ] else
          Text('No team data available.'),
        if (!isManager)
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String? _teamName = '';
                  String? _selectedGame;
                  List<String> _games = [
                    "MLBB",
                    "DOTA 2",
                    "CODM",
                    "Valorant",
                    "League of Legends",
                    "Wildrift"
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
                                _teamName = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Enter team name',
                              ),
                            ),
                            DropdownButton<String>(
                              value: _selectedGame,
                              hint: const Text('Select a game'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGame = newValue;
                                });
                              },
                              items: _games.map<DropdownMenuItem<String>>(
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
                              final managerId = userDetails.localId;
                              if (_teamName != null &&
                                  _teamName!.isNotEmpty &&
                                  _selectedGame != null &&
                                  managerId != null) {
                                createTeam(
                                  ref.read as ProviderContainer,
                                  _teamName!,
                                  _selectedGame!,
                                ).then((Map<String, dynamic> newTeamData) {
                                  // The team was created successfully
                                  print("Team was created: $newTeamData");
                                  ref.read(teamProvider.notifier).fetchTeams();
                                }).catchError((error) {
                                  // There was an error creating the team
                                  print("Error creating team: $error");
                                });
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
  }
}
