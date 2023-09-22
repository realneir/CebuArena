import 'package:captsone_ui/Screens/managerTeamProfile/widgets/calendarState.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
    print("Building Calendar Section"); // Add this line

    final events = ref.watch(calendarProvider);

    // Convert the events to a format that TableCalendar understands
    final Map<DateTime, List<Event>> eventMap = {};
    for (var event in events) {
      final DateTime eventDate = DateTime.parse(event['date'] ?? '2020-01-01');
      final String title = event['contact'] ?? 'No Title';

      eventMap.putIfAbsent(eventDate, () => []).add(Event(title: title));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        eventLoader: (day) {
          return eventMap[day] ?? [];
        },
      ),
    );
  }
}

class Event {
  final String title;

  Event({required this.title});
}
