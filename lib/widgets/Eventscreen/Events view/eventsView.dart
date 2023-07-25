// import 'package:captsone_ui/Screens/ManagerEventProfile/widgets/eventProfileBody.dart';
// import 'package:captsone_ui/Screens/ManagerEventProfile/widgets/eventTab.dart';
import 'package:captsone_ui/services/EventsProvider/fetchEvents.dart';
import 'package:captsone_ui/widgets/Eventscreen/Events%20view/eventsBody.dart';
import 'package:captsone_ui/widgets/Eventscreen/Events%20view/eventsTab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullEventPage extends ConsumerWidget {
  final Event event;

  FullEventPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double coverHeight = 150.0;
    double profileHeight = 75.0;

    final eventData = ref.watch(eventsProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Theme(
        data: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            toolbarTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: GoogleFonts.metalMania().fontFamily,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: GoogleFonts.metalMania().fontFamily,
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Full Event Details'), // change the title
          ),
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.28, // Change this to your desired height as a percentage of the screen height
                child: eventData.when(
                  data: (events) {
                    if (events.isEmpty) {
                      return Text('No events available.');
                    } else {
                      return EventProfileBody(
                        coverHeight: coverHeight,
                        profileHeight: profileHeight,
                        eventData: event.eventData,
                      );
                    }
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ),
              Expanded(
                child: EventsTab(event: event),
              ),
            ],
          ),
        ),
      );
    });
  }
}
