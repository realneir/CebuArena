import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final TabController tabController;

  const ProfileTab({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: TabBar(
            controller: tabController,
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
              controller: tabController,
              children: [
                buildAboutSection(),
                buildTeamsSection(),
                buildAlbumSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
