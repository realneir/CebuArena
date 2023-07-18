import 'dart:convert';
import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Team {
  final String teamId;
  final String teamName;
  final Map<String, dynamic> manager;
  final List<dynamic>? members;
  final String game;

  Team({
    required this.teamId,
    required this.teamName,
    required this.manager,
    this.members,
    required this.game,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['team_id'],
      teamName: json['team_name'],
      manager: json['manager'],
      members: json['members'],
      game: json['game'],
    );
  }
}

Future<List<Team>> fetchTeams() async {
  final url = Uri.parse('http://10.0.2.2:8000/get_all_teams/');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> teamsData = responseData['teams'];
      final List<Team> teams =
          teamsData.map((json) => Team.fromJson(json)).toList();
      print(teams);
      return teams;
    } else {
      throw Exception('Failed to fetch teams');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}

final teamsProvider = FutureProvider<List<Team>>((ref) async {
  return fetchTeams();
});

class TeamsList extends ConsumerWidget {
  const TeamsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'Teams',
            style: GoogleFonts.orbitron(
              fontSize: 24,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: tabs.map((tab) {
              return Tab(
                icon: tab.icon,
                text: tab.label,
              );
            }).toList(),
          ),
          titleSpacing: 20,
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            final teamsData = ref.watch(teamsProvider);
            return teamsData.when(
              data: (teams) {
                // Filter teams based on the selected game
                final teamsForTab =
                    teams.where((team) => team.game == tab.label).toList();

                return ListView.builder(
                  itemCount: teamsForTab.length,
                  itemBuilder: (context, index) {
                    final team = teamsForTab[index];
                    // Build your UI for each team item here...
                    return TeamDetailCard(team: team);
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Failed to fetch teams: $error')),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TeamDetailCard extends StatelessWidget {
  final Team team;

  const TeamDetailCard({required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/Slider1.jpg'),
                // Set the path to your team logo image
                radius: 25,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.teamName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manager: ${team.manager['username'] ?? ''}',
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
    );
  }
}
