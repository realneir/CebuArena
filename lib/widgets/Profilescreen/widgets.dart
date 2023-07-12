import 'package:captsone_ui/services/team.dart';
import 'package:flutter/material.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:provider/provider.dart';

Widget buildAboutSection() {
  return const Center(
    child: Text('About Section'),
  );
}

Widget buildTeamsSection(BuildContext context) {
  return Scaffold(
      body: const Center(
        child: Text('Teams Section'), //display the created team here
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final provider =
                    Provider.of<UserDetailsProvider>(context, listen: false);
                String? managerId = provider.localId;
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
                      mainAxisSize: MainAxisSize
                          .min, // add this line to handle overflowing issue
                      children: [
                        TextField(
                          onChanged: (value) {
                            _teamName =
                                value; // store the input value in _teamName variable
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
                              _selectedGame =
                                  newValue; // store the selected value in _selectedGame variable
                            });
                          },
                          items: _games
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                          // Check if team name, game and managerId are not null
                          if (_teamName != null &&
                              _teamName!.isNotEmpty &&
                              _selectedGame != null &&
                              managerId != null) {
                            createTeam(context, managerId, _teamName!,
                                    _selectedGame!)
                                .then((String result) {
                              // The team was created successfully
                              print("Team was created: $result");
                            }).catchError((error) {
                              // There was an error creating the team
                              print("Error creating team: $error");
                            });
                            Navigator.of(context).pop();
                          } else {
                            // Show an error if the team name, game or managerId is null
                            print(
                                "Please enter a team name, select a game, and ensure user is logged in.");
                          }
                        },
                      ),
                    ],
                  );
                });
              });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ));
}

Widget buildAlbumSection() {
  return const Center(
    child: Text('Album Section'),
  );
}

Widget buildCoverPhoto(double coverHeight) {
  return Container(
    width: double.infinity,
    height: coverHeight,
    decoration: const BoxDecoration(
      color: Colors.blue,
      image: DecorationImage(
        image: AssetImage('Slider1.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildProfilePhoto(double profileHeight) {
  return CircleAvatar(
    radius: profileHeight / 2,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        image: const DecorationImage(
          image: AssetImage('Slider2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget buildTagWithIcon(BuildContext context, String tag, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.blue,
        size: 16,
      ),
      const SizedBox(width: 5),
      Text(
        tag,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget buildTextWithPadding(
    String text, double fontSize, FontWeight fontWeight) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}
