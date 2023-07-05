import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';

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
    final profileWidth = MediaQuery.of(context).size.width * 0.3;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.6,
              child: buildCoverPhoto(widget.coverHeight),
            ),
            Positioned(
              left: profileWidth * 0.1,
              bottom: widget.coverHeight * 0.35,
              child: buildProfilePhoto(widget.profileHeight),
            ),
            Positioned(
              left: profileWidth * 0.1,
              bottom: widget.coverHeight * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextWithPadding('Master Leeroy', 20, FontWeight.bold),
                  buildTextWithPadding('@sojugaming', 14, FontWeight.normal),
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
                      buildTagWithIcon(context, 'Player', Icons.verified_user),
                      SizedBox(height: 5),
                      buildTagWithIcon(
                          context, 'Organizer', Icons.verified_user),
                    ],
                  ),
                  SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('View Org'),
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
