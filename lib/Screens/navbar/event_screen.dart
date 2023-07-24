import 'package:captsone_ui/widgets/Eventscreen/Eventsdetail.dart';
import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; // Update with the correct path to your tab_data.dart file

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
            return Container(
                // Empty container for each tab
                );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventCreationScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.black26,
        ),
      ),
    );
  }
}

// class eventsDetailCard extends StatelessWidget {
//   final Map<String, dynamic> scrim;

//   const eventsDetailCard({Key? key, required this.scrim}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage('assets/teamProfile.jpg'),
//               radius: 25,
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text(
//                   //   'Team: ${scrim['manager_id']}', // Add the team name placeholder
//                   //   style: const TextStyle(
//                   //     fontSize: 20,
//                   //     fontWeight: FontWeight.bold,
//                   //   ),
//                   // ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Date:', // Add the date placeholder
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     'Time:', // Add the time placeholder
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     ':', // Add the preferences placeholder
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     'Contact:', // Add the contact placeholder
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     'Manager:', // Add the manager placeholder
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
