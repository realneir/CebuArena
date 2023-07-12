import 'package:captsone_ui/widgets/Profilescreen/Profilebody.dart';
import 'package:captsone_ui/widgets/Profilescreen/Profiletab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late double coverHeight = 150.0; // Set a fixed value for coverHeight
  late double profileHeight = 75.0; // Set a fixed value for profileHeight
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Theme(
        data: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            toolbarTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30, // Fixed font size
              fontFamily: GoogleFonts.metalMania().fontFamily,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30, // Fixed font size
              fontFamily: GoogleFonts.metalMania().fontFamily,
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('CebuArena'),
          ),
          body: Column(
            children: [
              Container(
                height: coverHeight,
                child: ProfileBody(
                  coverHeight: coverHeight,
                  profileHeight: profileHeight,
                ),
              ),
              Expanded(
                child: ProfileTab(tabController: _tabController),
              ),
            ],
          ),
        ),
      );
    });
  }
}
