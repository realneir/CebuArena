import 'package:captsone_ui/Screens/Manager%20team%20Profile/widgets/tabs/requests.dart';
import 'package:captsone_ui/services/teamsProvider/create_team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsTab extends ConsumerStatefulWidget {
  @override
  _TeamsTabState createState() => _TeamsTabState();
}

class _TeamsTabState extends ConsumerState<TeamsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamData = ref.watch(teamProvider).firstOrNull;
    return Padding(
        padding: EdgeInsets.only(
            top: 30.0), // Adjust the top padding value as needed
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                tabs: [
                  Tab(text: 'About'),
                  Tab(text: 'Members'),
                  Tab(text: 'Join Requests'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildAboutSection(),
                    buildMembersSection(teamData!),
                    buildPendingRequestsSection(context, ref, teamData),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildAboutSection() {
    return Center(child: Text('About Section'));
  }

  Widget buildMembersSection(Map<String, dynamic>? teamData) {
    final List<dynamic> membersData = teamData?['members'] ?? [];
    final Iterable<Map<String, dynamic>> members = membersData
        .where((m) => m != null && m is Map<String, dynamic>)
        .cast<Map<String, dynamic>>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final member in members)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/Slider1.jpg'),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['username'] ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Member: ${member['username'] ?? ''}',
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
          ],
        ),
      ),
    );
  }
}
