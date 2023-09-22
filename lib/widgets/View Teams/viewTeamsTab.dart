import 'package:captsone_ui/services/teamsProvider/fetchTeams.dart';
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
        padding:
            EdgeInsets.only(top: 5.0), // Adjust the top padding value as needed
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
        elevation: 5, // to provide a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // to make corners rounded
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(
              Icons.account_circle,
              size: 40,
            ), // you can replace with actual member image
            radius: 20,
            backgroundColor: Colors.blue, // replace with your preferred color
          ),
          title: Text(
            titleText,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      );
    }).toList();

    return ListView(
      padding: EdgeInsets.all(10), // providing some space around your list
      children: memberCards,
    );
  }

  Widget buildAlbumSection() {
    return const Center(child: Text('Album Section'));
  }
}
