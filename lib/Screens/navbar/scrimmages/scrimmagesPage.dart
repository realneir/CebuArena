// ignore_for_file: sort_child_properties_last
import 'dart:convert';
import 'package:captsone_ui/Screens/navbar/scrimmages/scrimRequestPage.dart';
import 'package:http/http.dart' as http;
import 'package:captsone_ui/Screens/navbar/messages/chatPage.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:captsone_ui/services/scrimsProvider/fetchScrim.dart';
import 'package:captsone_ui/widgets/Scrimmage/scrimmageDetails.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:captsone_ui/widgets/Homepage/tabData.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrimmagesPage extends ConsumerWidget {
  const ScrimmagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final managerId = ref.watch(userDetailsProvider).localId;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'Scrimmages',
            style: GoogleFonts.orbitron(
              color: Colors.black,
              fontSize: 24,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            userDetails.isManager // Check if the user is a manager
                ? IconButton(
                    icon: Icon(Icons.phone_android),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScrimRequestPage()),
                      );
                    },
                  )
                : SizedBox.shrink(), // Show nothing if not a manager
          ],
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
            return StreamBuilder(
              stream: getAllScrimsByGame(tab.label, ref),
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
        floatingActionButton: userDetails.isManager
            ? FloatingActionButton(
                onPressed: () async {
                  await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(builder: (context) => Scrimmagedetails()),
                  );
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.black26,
              )
            : null, // Hide the FloatingActionButton if not a manager
      ),
    );
  }
}

class ScrimDetailCard extends ConsumerWidget {
  // Changed to ConsumerWidget
  final Map<String, dynamic> scrim;

  const ScrimDetailCard({Key? key, required this.scrim}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef is added
    return InkWell(
      onTap: () => _showDetailsDialog(context, ref),
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
                    ref.watch(teamNameProvider(scrim['manager_id'])).when(
                          data: (teamName) {
                            return Text(
                              'Team: $teamName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          loading: () => Text(
                            'Team: Loading...',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          error: (err, stack) => Text('Team: Error: $err'),
                        ),
                    Text(
                      'Manager: ${scrim['manager_username'] ?? 'default_value'}',
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

  Future<void> _requestScrim(WidgetRef ref) async {
    var url = Uri.parse('http://10.0.2.2:8000/request_scrim/');

    final managerId = ref.read(userDetailsProvider).localId;
    var response = await http.post(url, body: {
      'manager_id': managerId,
      'scrim_id': scrim['scrim_id'],
      'game': scrim['game'],
    });

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(
          'Scrim request sent successfully. Request id: ${responseBody['request_id']}');
    } else {
      print('Error while requesting scrim: ${response.body}');
    }
  }

  void _navigateToChat(BuildContext context) {
    print('Navigating to chat with user: ${scrim['manager_id']}');
    print('User\'s username: ${scrim['manager_username']}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userId: scrim['manager_id'],
          username: scrim['manager_username'],
        ),
      ),
    );
  }

  _showDetailsDialog(BuildContext context, ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scrimmage Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Date: ${scrim['date']}'),
                Text('Time: ${scrim['time']}'),
                Text('Preferences: ${scrim['preferences']}'),
                Text('Contact: ${scrim['contact']}'),
                Text('Manager: ${scrim['manager_username']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Contact'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToChat(context);
              },
            ),
            TextButton(
                child: Text('Request'),
                onPressed: () {
                  Navigator.of(context).pop();

                  _requestScrim(ref);
                })
          ],
        );
      },
    );
  }
}
