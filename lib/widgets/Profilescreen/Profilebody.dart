import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';

class ProfileBody extends StatefulWidget {
  final double coverHeight;
  final double profileHeight;

  const ProfileBody({
    required this.coverHeight,
    required this.profileHeight,
  });

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserDetailsProvider>(context).username;

    final profileWidth = MediaQuery.of(context).size.width * 0.3;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.6,
              child: buildCoverPhoto(widget
                  .coverHeight), // This will depend on how you implemented buildCoverPhoto function
            ),
            Positioned(
              left: profileWidth * 0.1,
              bottom: widget.coverHeight * 0.35,
              child: buildProfilePhoto(widget
                  .profileHeight), // This will depend on how you implemented buildProfilePhoto function
            ),
            Positioned(
              left: profileWidth * 0.1,
              bottom: widget.coverHeight * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextWithPadding(
                      'Master Leeroy', 20, FontWeight.bold, Colors.black),
                  buildTextWithPadding(
                      '@$username', 14, FontWeight.normal, Colors.grey),
                ],
              ),
            ),
            Positioned(
              left: profileWidth * 1.2,
              bottom: widget.coverHeight * 0.3,
              child: Row(
                children: [
                  Column(
                    children: [
                      buildTagWithIcon(
                          context, 'Player', Icons.verified_user, Colors.black),
                      SizedBox(height: 5),
                      buildTagWithIcon(context, 'Organizer',
                          Icons.verified_user, Colors.black),
                    ],
                  ),
                  SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('View Org'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

Text buildTextWithPadding(
    String text, double size, FontWeight weight, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
    ),
  );
}

Widget buildTagWithIcon(
    BuildContext context, String text, IconData icon, Color color) {
  return Row(
    children: [
      IconTheme(
        data: IconThemeData(
          color: color,
        ),
        child: Icon(icon),
      ),
      SizedBox(width: 5),
      Text(
        text,
        style: TextStyle(color: color),
      ),
    ],
  );
}
