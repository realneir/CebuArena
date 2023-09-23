import 'package:captsone_ui/Screens/managerTeamProfile/widgets/tabs/requests.dart';
import 'package:captsone_ui/services/teamsProvider/createTeam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the package

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
    _tabController =
        TabController(length: 4, vsync: this); // Increase length to 4
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
        padding: EdgeInsets.only(top: 10.0),
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
                  Tab(text: 'Calendar'), // Add Calendar tab
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildAboutSection(),
                    buildMembersSection(teamData ?? {}),
                    buildPendingRequestsSection(context, ref, teamData ?? {}),
                    buildCalendarSection(ref),
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

  Widget buildMembersSection(Map<String, dynamic> teamData) {
    final List<dynamic> membersData = teamData['members'] ?? [];
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

  Widget buildCalendarSection(WidgetRef ref) {
    // You can fetch the list of scrims from your backend or state management solution
    List<Scrim> scrims = [
      // Example scrims
      Scrim(date: DateTime.now(), details: 'Scrim 1 Details'),
      Scrim(
          date: DateTime.now().add(Duration(days: 2)),
          details: 'Scrim 2 Details'),
    ];

    Map<DateTime, List<Scrim>> scrimEvents = {};
    for (var scrim in scrims) {
      final date = DateTime(scrim.date.year, scrim.date.month, scrim.date.day);
      if (scrimEvents[date] == null) scrimEvents[date] = [];
      scrimEvents[date]!.add(scrim);
    }

    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      eventLoader: (day) {
        return scrimEvents[day] ?? [];
      },
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {
        // Show scrim details when a day with a scrim is selected
        final scrims = scrimEvents[selectedDay];
        if (scrims != null && scrims.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Scrim Details'),
              content: Text(scrims.first
                  .details), // Show details of the first scrim on that day
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class Scrim {
  final DateTime date;
  final String details;
  // Add other fields as needed

  Scrim({required this.date, required this.details});
}
