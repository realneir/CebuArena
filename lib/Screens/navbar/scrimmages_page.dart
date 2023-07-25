// ignore_for_file: sort_child_properties_last
import 'package:captsone_ui/services/scrimsProvider/fetch_scrim.dart';
import 'package:captsone_ui/widgets/Scrimmage/scrimmage_details.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrimmagesPage extends ConsumerWidget {
  const ScrimmagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'Scrimmages',
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
            return FutureBuilder(
              future: getAllScrimsByGame(tab.label, ref),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var scrim = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ScrimDetailCard(scrim: scrim),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (context) => Scrimmagedetails()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.black26,
        ),
      ),
    );
  }
}

class ScrimDetailCard extends StatelessWidget {
  final Map<String, dynamic> scrim;

  const ScrimDetailCard({Key? key, required this.scrim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  FutureBuilder(
                    future: fetchTeamName(scrim['manager_id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Team: Loading...',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Team: Error: ${snapshot.error}');
                      } else {
                        final teamName = snapshot.data as String? ?? 'N/A';
                        return Text(
                          '$teamName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${scrim['date']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Time: ${scrim['time']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Preferences: ${scrim['preferences']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Contact: ${scrim['contact']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Manager: ${scrim['manager_username']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
