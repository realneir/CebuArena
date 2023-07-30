import 'package:captsone_ui/Screens/Manager%20team%20Profile/widgets/teamProfileBody.dart';
import 'package:captsone_ui/services/teamsProvider/fetchTeams.dart';
import 'package:captsone_ui/widgets/View%20Teams/teamViewProfileBody.dart';
import 'package:captsone_ui/widgets/View%20Teams/viewTeamsTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewTeam extends ConsumerWidget {
  final Team team;
  const ViewTeam({required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TeamProfile'),
        ),
        body: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.28,
                child: ViewTeamBody(
                  team: team,
                )),
            Expanded(
              child: viewTeamsTab(
                team: team,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
