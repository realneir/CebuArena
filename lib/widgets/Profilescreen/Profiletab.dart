// ignore_for_file: library_private_types_in_public_api

import 'package:captsone_ui/services/teamsProvider/createTeam.dart';
import 'package:captsone_ui/widgets/Profilescreen/profile%20tabs/buildAboutSection.dart';
import 'package:captsone_ui/widgets/Profilescreen/profile%20tabs/buildAlbumSection.dart';
import 'package:captsone_ui/widgets/Profilescreen/profile%20tabs/buildTeamsSection.dart';
import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch the teams when the widget is created
    ref.read(teamProvider.notifier).fetchTeams();
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
            labelStyle: const TextStyle(fontFamily: 'Montserrat', fontSize: 16),
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Teams'),
              Tab(text: 'Album'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              AboutSection(),
              TeamsSection(),
              AlbumSection(),
            ],
          ),
        ),
      ],
    );
  }
}
