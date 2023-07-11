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
  double? coverHeight;
  double? profileHeight;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        coverHeight = MediaQuery.of(context).size.height * 0.3;
        profileHeight = coverHeight! * 0.5;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (coverHeight == null || profileHeight == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            toolbarTextStyle: TextTheme(
              headline6: TextStyle(
                color: Colors.black,
                fontSize: 30 * (screenWidth / 720), // Responsive font size
                fontFamily: GoogleFonts.metalMania().fontFamily,
              ),
            ).bodyText2,
            titleTextStyle: TextTheme(
              headline6: TextStyle(
                color: Colors.black,
                fontSize: 30 * (screenWidth / 720), // Responsive font size
                fontFamily: GoogleFonts.metalMania().fontFamily,
              ),
            ).headline6,
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
                height: constraints.maxHeight * 0.4,
                child: ProfileBody(
                  coverHeight: screenHeight *
                      (constraints.maxHeight > 600
                          ? 0.3
                          : 0.2), // Adjust coverHeight based on height of the screen
                  profileHeight: profileHeight! *
                      (constraints.maxHeight > 600
                          ? 0.5
                          : 0.4), // Adjust profileHeight based on height of the screen
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
