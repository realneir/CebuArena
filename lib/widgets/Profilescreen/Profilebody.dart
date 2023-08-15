import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: coverHeight,
              child: buildCoverPhoto(coverHeight),
            ),
            Positioned(
              left: 20,
              top: coverHeight - (profileHeight / 1.5),
              child: buildProfilePhoto(profileHeight),
            ),
            Positioned(
              left: 20,
              top: coverHeight - (profileHeight / 1.3) + profileHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column 1 - First and Last Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextWithPadding(
                          '$firstname $lastname', 20, FontWeight.bold),
                      buildTextWithPadding('@$username', 14, FontWeight.normal),
                    ],
                  ),

                  // Column 2 - Manager Field
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, left: 40.0), // Add left padding here
                        child: Row(
                          children: [
                            if (userDetails.isManager || userDetails.isMember)
                              const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.check,
                                    color: Colors.white,
                                    size: 14), // Adjust the size of the icon here
                              ),
                            const SizedBox(width: 8.0),
                            if (userDetails.isManager)
                              buildTextWithPadding('Manager', 14, FontWeight.bold),
                            if (userDetails.isMember)
                              buildTextWithPadding('Member', 14, FontWeight.bold),
                          ],
                        ),
                      ),
                      // Create Org Button
                      Padding(
                        padding: EdgeInsets.only(left: 40.0), // Add left padding here
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Create Org'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                        ),
                      ),
                    ],
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
