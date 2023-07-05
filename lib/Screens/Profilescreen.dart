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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (coverHeight == null || profileHeight == null) {
      return Container(); // Placeholder widget when the heights are not yet initialized
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CebuArena',
          style: GoogleFonts.metalMania(fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ProfileBody(
              coverHeight: coverHeight!,
              profileHeight: profileHeight!,
            ),
          ),
          Expanded(
            child: ProfileTab(tabController: _tabController),
          ),
        ],
      ),
    );
  }
}
