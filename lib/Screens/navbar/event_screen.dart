// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:captsone_ui/widgets/Eventscreen/Eventsdetail.dart';
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
            const SizedBox(height: 10),
            Text('Description: ${widget.event.description}'),
            const SizedBox(height: 10),
            Text('Contact Details: ${widget.event.contactDetails}'),
            const SizedBox(height: 10),
            Text('Rules: ${widget.event.rules}'),
            const SizedBox(height: 10),
            Text('Prize: ${widget.event.prize}'),
            const SizedBox(height: 10),
            Text('Schedule: ${widget.event.schedule}'),
            const SizedBox(height: 10),
            Text('Minimum Players: ${widget.event.minPlayers}'),
            const SizedBox(height: 10),
            Text('Maximum Players: ${widget.event.maxPlayers}'),
            const SizedBox(height: 10),
            Text('Registration Limit: ${widget.event.registrationLimit}'),
            const SizedBox(height: 10),
            Text('Participants Limit: ${widget.event.participantsLimit}'),
            const SizedBox(height: 10),
            Text('Challong Link: ${widget.event.challongLink}'),
            const SizedBox(height: 10),
            Text('Registration Location: ${widget.event.registrationLocation}'),
            const SizedBox(height: 10),
            Text(
                'Specific Specification: ${widget.event.specificSpecification}'),
            const SizedBox(height: 10),
            Text('Specific Town: ${widget.event.specificTown}'),
          ],
        ),
      ),
    );
  }
}
