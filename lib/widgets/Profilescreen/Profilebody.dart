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
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    final username = userDetailsProvider.username;
    final firstname = userDetailsProvider.firstname;
    final lastname = userDetailsProvider.lastname;

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
                      '$firstname $lastname', 20, FontWeight.bold),
                  buildTextWithPadding('@$username', 14, FontWeight.normal),
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
