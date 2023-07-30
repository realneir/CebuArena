import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamProfileBody extends ConsumerWidget {
  final double coverHeight;
  final double profileHeight;
  final Map<String, dynamic> teamData;

  const TeamProfileBody({
    required this.coverHeight,
    required this.profileHeight,
    required this.teamData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamName = teamData['team_name'] ?? '';

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
              top: coverHeight - (profileHeight / 1.4),
              child: buildProfilePhoto(profileHeight),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: coverHeight + (profileHeight / 5),
              bottom: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Join Team'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
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

Widget buildProfilePhoto(double profileHeight) {
  return Container(
    width: profileHeight,
    height: profileHeight,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      image: const DecorationImage(
        image: AssetImage('assets/teamProfile.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildCoverPhoto(double coverHeight) {
  return Container(
    width: double.infinity,
    height: coverHeight,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/teamLogo.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
