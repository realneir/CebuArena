import 'package:captsone_ui/Screens/Eventsdetail.dart';
import 'package:captsone_ui/Screens/Leaderboards.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:captsone_ui/Screens/Scrimmagespage.dart';
import 'package:captsone_ui/widgets/Homepage/drawer.dart';
import 'package:captsone_ui/widgets/Homepage/events_leaderboards_page.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';

class CurrentIndexNotifier extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class Homepage extends StatefulWidget {
  final String? username;

  const Homepage({Key? key, this.username}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserDetailsProvider>(context).username;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'blackLogo.png',
                width: 40,
                height: 40,
              ),
              SizedBox(width: 10),
              Text(
                'CebuArena ',
                style:
                    GoogleFonts.metalMania(fontSize: 30, color: Colors.black),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        elevation: 20,
        titleSpacing: 20,
      ),
      drawer: SidebarMenu(
        username: '$username',
      ),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Scrimmages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.montserrat(),
        unselectedLabelStyle: GoogleFonts.montserrat(),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return ScrimmagesPage();
      case 2:
        return Leaderboards();
      case 3:
        return EventCreationPage();
      default:
        return Container();
    }
  }
}
