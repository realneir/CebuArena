import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:captsone_ui/services/auth_provider.dart';

class ProfileBody extends ConsumerWidget {
  final double coverHeight;
  final double profileHeight;

  const ProfileBody({
    required this.coverHeight,
    required this.profileHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final username = userDetails.username;
    final firstname = userDetails.firstname;
    final lastname = userDetails.lastname;
    final isManager = userDetails.isManager;

    final profileWidth = MediaQuery.of(context).size.width * 0.3;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.6,
              child: buildCoverPhoto(coverHeight),
            ),
            Positioned(
              left: profileWidth * 0.1,
              bottom: coverHeight * 0.35,
              child: buildProfilePhoto(profileHeight),
            ),
            Positioned(
              left: profileWidth * 0.1,
              bottom: coverHeight * 0.1,
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
              bottom: coverHeight * 0.3,
              child: Row(
                children: [
                  Column(
                    children: [
                      if (isManager) // Conditionally display the "Manager" tag
                        buildTagWithIcon(
                            context, 'Manager', Icons.verified_user),
                      SizedBox(height: 5),
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
