import 'package:captsone_ui/widgets/Profilescreen/profileBody.dart';
import 'package:captsone_ui/widgets/Profilescreen/profileTab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // import ConsumerWidget and WidgetRef

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double coverHeight = 150.0;
    double profileHeight = 75.0;

    return LayoutBuilder(builder: (context, constraints) {
      return Theme(
        data: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
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
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.deepPurpleAccent),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('CebuArena'),
          ),
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.28, // Change this to your desired height as a percentage of the screen height
                child: ProfileBody(
                  coverHeight: coverHeight,
                  profileHeight: profileHeight,
                ),
              ),
              Expanded(
                child: ProfileTab(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
