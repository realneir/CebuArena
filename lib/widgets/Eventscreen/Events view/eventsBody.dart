import 'package:captsone_ui/Screens/managerTeamProfile/widgets/teamProfileBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventProfileBody extends ConsumerWidget {
  final double coverHeight;
  final double profileHeight;
  final Map<String, dynamic> eventData;

  const EventProfileBody({
    required this.coverHeight,
    required this.profileHeight,
    required this.eventData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventName = eventData['event_name'] ?? '';

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
                    eventName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Join Event'),
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
