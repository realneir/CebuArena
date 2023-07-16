import 'package:captsone_ui/widgets/Leaderboards/subcategory.dart';
import 'package:flutter/material.dart';

class Leaderboards extends StatefulWidget {
  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue[900],
              indicatorColor: Colors.blue[900],
              indicatorWeight: 5,
              tabs: [
                Tab(text: 'MLBB'),
                Tab(text: 'VALORANT'),
                Tab(text: 'DOTA2'),
                Tab(text: 'CODM'),
                Tab(text: 'LOL'),
                Tab(text: 'WILDRIFT'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SubCategoryPage(mainCategory: 'MLBB'),
                  SubCategoryPage(mainCategory: 'VALORANT'),
                  SubCategoryPage(mainCategory: 'DOTA2'),
                  SubCategoryPage(mainCategory: 'CODM'),
                  SubCategoryPage(mainCategory: 'LOL'),
                  SubCategoryPage(mainCategory: 'WILDRIFT'),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
