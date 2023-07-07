import 'package:captsone_ui/widgets/Scrimmage/Scrimmagedetails.dart';
import 'package:flutter/material.dart';
import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrimmagesPage extends StatefulWidget {
  @override
  _ScrimmagesPageState createState() => _ScrimmagesPageState();
}

class _ScrimmagesPageState extends State<ScrimmagesPage> {
  Map<String, Map<String, dynamic>> scrimmagesResults = {};

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
            return ListView(
              children: scrimmagesResults.entries.map((entry) {
                if (entry.key == tab.label) {
                  return Dismissible(
                    key: Key(entry.key),
                    onDismissed: (direction) {
                      setState(() {
                        scrimmagesResults.remove(entry.key);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${entry.key} Scrim cancelled")),
                      );
                    },
                    child: ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    ),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (context) => ScrimmageDetails()),
            );

            if (result != null) {
              setState(() {
                scrimmagesResults[result['game']] = result;
              });
            }

            print(scrimmagesResults);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
