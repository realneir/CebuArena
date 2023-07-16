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
    return Column(
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
                buildMembersSection(),
                buildPendingRequestsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAboutSection() {
    return Center(child: Text('About Section'));
  }

  Widget buildMembersSection() {
    return Center(child: Text('Members Section'));
  }

  Widget buildPendingRequestsSection() {
    return Center(child: Text('Pending Requests Section'));
  }
}

Widget buildAboutSection() {
  return Center(child: Text('About Section'));
}

Widget buildMembersSection() {
  return Center(child: Text('Members Section'));
}

Widget buildPendingRequestsSection() {
  return Center(child: Text('Pending Requests Section'));
}
