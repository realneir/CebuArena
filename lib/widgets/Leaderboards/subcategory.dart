import 'package:captsone_ui/widgets/Leaderboards/placeholder.dart';
import 'package:flutter/material.dart';

class SubCategoryPage extends StatelessWidget {
  final String mainCategory;

  SubCategoryPage({required this.mainCategory});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: false,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.blue[300],
            tabs: [
              Tab(text: 'PLAYERS'),
              Tab(text: 'TEAMS'),
              Tab(text: 'CESAFI Schools'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildPlaceholderContent(mainCategory, 'PLAYERS'),
            buildPlaceholderContent(mainCategory, 'TEAMS'),
            buildPlaceholderContent(mainCategory, 'CESAFI Schools'),
          ],
        ),
      ),
    );
  }
}
