import 'package:captsone_ui/widgets/Leaderboards/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class leaderBoards extends StatefulWidget {
  @override
  _leaderBoardsState createState() => _leaderBoardsState();
}

class _leaderBoardsState extends State<leaderBoards>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'CebuArena',
            style: GoogleFonts.metalMania(
              fontSize: 30,
              color: Colors.blue[900],
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            color: Colors.blue,
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              color: Colors.blue,
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: TabBar(
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
          elevation: 20,
          titleSpacing: 20,
        ),
        body: TabBarView(
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
      );

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
