// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:captsone_ui/services/teamsProvider/fetch_teams.dart';
import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:captsone_ui/widgets/View%20Teams/profileTeam.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              color: Colors.black,
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
                final teamsForTab =
                    teams.where((team) => team.game == tab.label).toList();

                return ListView.builder(
                  itemCount: teamsForTab.length,
                  itemBuilder: (context, index) {
                    final team = teamsForTab[index];
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

class TeamDetailCard extends ConsumerWidget {
  final Team team;

  const TeamDetailCard({required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Add your redirection logic here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ViewTeam(team: team), // Replace this with your ViewTeam class
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/Slider1.jpg'),
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
      ),
    );
  }
}
