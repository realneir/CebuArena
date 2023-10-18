import 'package:captsone_ui/Screens/managerTeamProfile/widgets/teamProfileBody.dart'; // Import your event-related code here
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:captsone_ui/services/EventsProvider/joinEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventProfileBody extends ConsumerWidget {
  final double coverHeight;
  final double profileHeight;
  final Map<String, dynamic> eventData;
  final String eventId; // Add this to receive the eventId

  const EventProfileBody({
    required this.coverHeight,
    required this.profileHeight,
    required this.eventData,
    required this.eventId, // Add this parameter
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
              child: buildCoverPhoto(coverHeight), // Implement this function
            ),
            Positioned(
              left: 20,
              top: coverHeight - (profileHeight / 2),
              child:
                  buildProfilePhoto(profileHeight), // Implement this function
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
                      onPressed: () async {
                        // Get localId from userdetails provider
                        final userDetails = ref.watch(userDetailsProvider);
                        final localId = userDetails.localId;

                        try {
                          // Call the function to join the event
                          await JoinEventProvider.joinEvent(eventId, localId!);

                          // If the join is successful, show a confirmation dialog.
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Successfully Joined Event'),
                                content: Text(
                                    'You have successfully joined this event.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // You can add additional actions or navigation here.
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (error) {
                          // Handle the error, e.g., show an error message to the user
                          print('Error joining event: $error');
                          // You can show an error dialog here if needed.
                        }
                      },
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
