import 'package:captsone_ui/widgets/Profilescreen/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';

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
                  if (userDetails.isManager) // Check if the user is a manager
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 40.0), // Add left padding here
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius:
                                10, // Adjust the size of the circular background here
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check,
                                color: Colors.white,
                                size: 14), // Adjust the size of the icon here
                          ),
                          const SizedBox(
                              width:
                                  8.0), // Add a space between the icon and text
                          buildTextWithPadding('Manager', 14, FontWeight.bold),
                        ],
                      ),
                    ),

                  // Column 3 - View Org Button
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0), // Add left padding here
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Create Org'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                        ),
                      ],
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
