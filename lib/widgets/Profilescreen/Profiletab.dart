import 'dart:async';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/services/team.dart';
import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  final TabController tabController;

  const ProfileTab({required this.tabController});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late StreamController<Map<String, dynamic>> teamStreamController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserDetailsProvider>(context, listen: false);
    String? managerId = provider.localId;
    teamStreamController = StreamController<Map<String, dynamic>>.broadcast();
    teamStreamController = streamTeam(managerId!, context);
  }

  @override
  void dispose() {
    teamStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: TabBar(
            controller: widget.tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Teams'),
              Tab(text: 'Album'),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: TabBarView(
              controller: widget.tabController,
              children: [
                buildAboutSection(),
                buildTeamsSection(context, teamStreamController),
                buildAlbumSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
