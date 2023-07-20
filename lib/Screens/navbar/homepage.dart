import 'package:captsone_ui/Screens/navbar/messages/chat_page.dart';
import 'package:captsone_ui/Screens/navbar/messages/user_list.dart';
import 'package:captsone_ui/Screens/navbar/scrimmages_page.dart';
import 'package:captsone_ui/models/user_model.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/widgets/Eventscreen/Eventsdetail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:captsone_ui/widgets/Homepage/drawer.dart';
import 'package:captsone_ui/widgets/Homepage/events_leaderboards_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:captsone_ui/Screens/navbar/teamlist.dart';

final currentIndexProvider = ChangeNotifierProvider<CurrentIndexNotifier>(
  (ref) => CurrentIndexNotifier(),
);

class CurrentIndexNotifier extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class Homepage extends ConsumerWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final currentIndex = ref.watch(currentIndexProvider);
    final username =
        ref.watch(userDetailsProvider).username ?? 'username is not passed';

    debugPrint('Username: $username');
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        key: UniqueKey(),
        leading: IconButton(
          color: Colors.blue[300],
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/blackLogo.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(
              'CebuArena',
              style: GoogleFonts.metalMania(fontSize: 30, color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.blue[300],
            icon: const Icon(Icons.notifications_none),
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
        username: username,
      ),
      body: _buildPage(ref, currentIndex.currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.currentIndex,
        onTap: (index) {
          currentIndex.setCurrentIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Scrimmages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.montserrat(),
        unselectedLabelStyle: GoogleFonts.montserrat(),
      ),
    );
  }

  Widget _buildPage(WidgetRef ref, int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return ScrimmagesPage();
      case 2:
        return TeamsList();
      case 3:
      // return EventCreationPage();
      case 4:
        return UserListPage();

      default:
        return Container();
    }
  }
}
