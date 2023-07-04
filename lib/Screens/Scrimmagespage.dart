import 'package:flutter/material.dart';
import 'package:captsone_ui/widgets/tab_data.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrimmagesPage extends StatefulWidget {
  @override
  _ScrimmagesPageState createState() => _ScrimmagesPageState();
}

class _ScrimmagesPageState extends State<ScrimmagesPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Scrimmages',
            style: GoogleFonts.orbitron(
              fontSize: 24,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: tabs.map((tab) {
              return Tab(
                icon: tab.icon,
                text: tab.label,
              );
            }).toList(),
          ),
          titleSpacing: 20,
        ),
        body: TabBarView(
          children: [
            buildPage('Scrimmages'),
            buildPage('Scrimmages'),
            buildPage('Profile Page'),
            buildPage('Settings Page'),
          ],
        ),
      ),
    );
  }

  Widget buildPage(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 28),
      ),
    );
  }
}
