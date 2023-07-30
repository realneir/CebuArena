import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:captsone_ui/services/teamsProvider/fetchTeams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewTeamBody extends ConsumerWidget {
  final Team team;
  ViewTeamBody({required this.team});
  final double coverHeight = 130;
  final double profileHeight = 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              top: coverHeight - (profileHeight / 2),
              child: buildProfilePhoto(profileHeight),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: coverHeight + (profileHeight / 2),
              bottom: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    team.teamName, // use team object here
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Get localId from userdetails provider
                          final userDetails = ref.watch(userDetailsProvider);
                          final localId = userDetails.localId;

                          // Call the function to join team
                          await joinProvider.joinTeam(team.teamId, localId!);
                        },
                        child: const Text('Join Team'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
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
}
