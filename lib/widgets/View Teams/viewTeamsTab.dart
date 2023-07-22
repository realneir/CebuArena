import 'package:captsone_ui/services/teamsProvider/fetch_teams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class viewTeamsTab extends ConsumerStatefulWidget {
  final Team team;

  viewTeamsTab({required this.team});

  @override
  _viewTeamsTabState createState() => _viewTeamsTabState();
}

class _viewTeamsTabState extends ConsumerState<viewTeamsTab>
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
                  Tab(text: 'Album'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildAboutSection(),
                    buildMembersSection(),
                    buildAlbumSection(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildAboutSection() {
    return const Center(child: Text('About Section'));
  }

  Widget buildMembersSection() {
    // First, we create a copy of the members list to avoid modifying the original
    List<dynamic> members = List.from(widget.team.members ?? []);

    // Insert the manager at the beginning of the list
    members.insert(0, widget.team.manager);

    // Map over the members list and create a Card for each member
    List<Widget> memberCards = members.asMap().entries.map<Widget>((entry) {
      int idx = entry.key;
      Map<String, dynamic> member = entry.value;

      // Determine whether the member is a manager
      String titleText =
          (idx == 0) ? "Manager: ${member['username']}" : member['username'];

      return Card(
        child: ListTile(
          leading: Icon(Icons.account_circle), // Use your preferred icon
          title: Text(titleText),
        ),
      );
    }).toList();

    return ListView(
      children: memberCards,
    );
  }

  Widget buildAlbumSection() {
    return const Center(child: Text('Album Section'));
  }
}
