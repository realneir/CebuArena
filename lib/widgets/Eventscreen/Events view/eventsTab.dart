import 'package:captsone_ui/services/EventsProvider/fetchEvents.dart';
import 'package:captsone_ui/widgets/Eventscreen/Events%20view/tabs/description.dart';
import 'package:captsone_ui/widgets/Eventscreen/Events%20view/tabs/rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsTab extends ConsumerStatefulWidget {
  final Event event;

  EventsTab({Key? key, required this.event}) : super(key: key);

  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends ConsumerState<EventsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 30.0), // Adjust the top padding value as needed
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                tabs: [
                  Tab(text: 'Description'),
                  Tab(text: 'Rules'),
                  Tab(text: 'Teams Joined'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Description(event: widget.event),
                    Rules(event: widget.event),
                    buildTeamsJoinedSection(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildTeamsJoinedSection() {
    return Center(
        child:
            Text('Teams Joined Section')); // Add your teams joined section here
  }
}
