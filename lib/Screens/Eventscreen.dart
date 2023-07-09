// ignore_for_file: library_private_types_in_public_api

import 'package:captsone_ui/Screens/Eventsdetail.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  EventScreen({required this.event});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.eventName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Game: ${widget.event.game}'),
            SizedBox(height: 10),
            Text('Description: ${widget.event.description}'),
            SizedBox(height: 10),
            Text('Contact Details: ${widget.event.contactDetails}'),
            SizedBox(height: 10),
            Text('Rules: ${widget.event.rules}'),
            SizedBox(height: 10),
            Text('Prize: ${widget.event.prize}'),
            SizedBox(height: 10),
            Text('Schedule: ${widget.event.schedule}'),
            SizedBox(height: 10),
            Text('Minimum Players: ${widget.event.minPlayers}'),
            SizedBox(height: 10),
            Text('Maximum Players: ${widget.event.maxPlayers}'),
            SizedBox(height: 10),
            Text('Registration Limit: ${widget.event.registrationLimit}'),
            SizedBox(height: 10),
            Text('Participants Limit: ${widget.event.participantsLimit}'),
            SizedBox(height: 10),
            Text('Challong Link: ${widget.event.challongLink}'),
            SizedBox(height: 10),
            Text('Registration Location: ${widget.event.registrationLocation}'),
            SizedBox(height: 10),
            Text(
                'Specific Specification: ${widget.event.specificSpecification}'),
            SizedBox(height: 10),
            Text('Specific Town: ${widget.event.specificTown}'),
          ],
        ),
      ),
    );
  }
}
