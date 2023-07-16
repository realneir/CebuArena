import 'package:flutter/material.dart';
import 'package:captsone_ui/widgets/Homepage/tab_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scrimmagesResultsProvider =
    Provider<Map<String, Map<String, dynamic>>>((ref) {
  // Fetch scrimmagesResults data from your provider
  // Replace this with your actual data source or provider
  return {}; // Initial empty value
});

class TeamsList extends ConsumerWidget {
  const TeamsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'Teams',
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
        body: SizedBox.shrink(), // Empty body
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     final result = await Navigator.push<Map<String, dynamic>>(
        //       context,
        //       MaterialPageRoute(builder: (context) => Scrimmagedetails()),
        //     );

        //     if (result != null) {
        //       context.read(scrimmagesResultsProvider)[result['game']] = result;
        //     }

        //     print(context.read(scrimmagesResultsProvider));
        //   },
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.black26,
        // ),
      ),
    );
  }
}
