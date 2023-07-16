import 'package:captsone_ui/services/scrim.dart';
import 'package:captsone_ui/widgets/Scrimmage/Scrimmagedetails.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrimmagesPage extends ConsumerWidget {
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
            return ListView();
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (context) => Scrimmagedetails()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black26,
        ),
      ),
    );
  }
}
