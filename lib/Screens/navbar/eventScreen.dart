import 'package:captsone_ui/services/EventsProvider/fetchEvents.dart'; // Assuming this is the location of your eventsProvider
import 'package:captsone_ui/widgets/Eventscreen/Events%20view/eventsView.dart';
import 'package:captsone_ui/widgets/Eventscreen/eventDetails.dart';
import 'package:captsone_ui/widgets/Homepage/tabData.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsPage extends ConsumerWidget {
  EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'Events',
            style: GoogleFonts.orbitron(
              color: Colors.black,
              fontSize: 24,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: tabs.map((tab) {
              return Tab(
                icon: tab.icon,
                text: tab.label,
              );
            }).toList(),
          ),
          titleSpacing: 20,
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            final eventsData = ref.watch(eventsProvider);
            return eventsData.when(
              data: (events) {
                final eventsForTab = events
                    .where((event) => event.selectedGame == tab.label)
                    .toList();

                return ListView.builder(
                  itemCount: eventsForTab.length,
                  itemBuilder: (context, index) {
                    final event = eventsForTab[index];
                    return EventDetailCard(
                        event: event); // Your EventDetailCard goes here
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Failed to fetch events: $error')),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventCreationScreen(),
              ),
            );
            ref.read(eventsProvider.notifier).refreshEvents();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.black26,
        ),
      ),
    );
  }
}

class EventDetailCard extends StatelessWidget {
  final Event event;

  const EventDetailCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullEventPage(
                  event:
                      event)), // Assuming FullEventPage is your detailed event page
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/teamProfile.jpg'),
                radius: 25,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event: ${event.eventData['event_name']}', // Add the event name placeholder
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Organizer: ${event.eventData['creator_username'] != null ? event.eventData['creator_username'] : 'No organizer'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
