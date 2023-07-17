import 'package:captsone_ui/Screens/teams%20Profile/widgets/teamProfileBody.dart';
import 'package:captsone_ui/Screens/teams%20Profile/widgets/teamTab.dart';
import 'package:captsone_ui/services/Teams%20provider/team.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double coverHeight = 150.0;
    double profileHeight = 75.0;

    final teamData = ref.watch(teamProvider).firstOrNull;

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
              fontSize: 30,
              fontFamily: GoogleFonts.metalMania().fontFamily,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: GoogleFonts.metalMania().fontFamily,
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('TeamProfile'), // change the title
          ),
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.28, // Change this to your desired height as a percentage of the screen height
                child: teamData != null
                    ? TeamProfileBody(
                        coverHeight: coverHeight,
                        profileHeight: profileHeight,
                        teamData: teamData,
                      )
                    : Center(
                        child: Text('No team data available.'),
                      ),
              ),
              Expanded(
                child: TeamsTab(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
