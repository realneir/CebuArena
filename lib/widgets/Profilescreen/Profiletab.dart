import 'dart:async';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:captsone_ui/services/team.dart';
import 'package:captsone_ui/widgets/Profilescreen/profile%20tabs/buildTeamsSection.dart';
import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab>
    with SingleTickerProviderStateMixin {
  late StreamController<Map<String, dynamic>> teamStreamController;
  late TabController _tabController;
  String? managerId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    teamStreamController = StreamController<Map<String, dynamic>>.broadcast();
  }

  @override
  void dispose() {
    _tabController.dispose();
    teamStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(userDetailsProvider);
    managerId = provider.localId;
    teamStreamController = streamTeam(managerId!, context);

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
              Tab(text: 'Teams'),
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
                TeamsSection(teamStreamController: teamStreamController),
                buildAlbumSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
