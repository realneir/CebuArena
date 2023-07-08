import 'package:flutter/material.dart';
import 'package:captsone_ui/Screens/Eventscreen.dart';

class Event {
  final String eventName;
  final String game;
  final String description;
  final String contactDetails;
  final String rules;
  final String prize;
  final String schedule;
  final String minPlayers;
  final String maxPlayers;
  final String registrationLimit;
  final String participantsLimit;
  final String challongLink;
  final String registrationLocation;
  final String specificSpecification;
  final String specificTown;

  Event({
    required this.eventName,
    required this.game,
    required this.description,
    required this.contactDetails,
    required this.rules,
    required this.prize,
    required this.schedule,
    required this.minPlayers,
    required this.maxPlayers,
    required this.registrationLimit,
    required this.participantsLimit,
    required this.challongLink,
    required this.registrationLocation,
    required this.specificSpecification,
    required this.specificTown,
  });
}

class EventCreationPage extends StatefulWidget {
  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _games = [
    "MLBB",
    "VALORANT",
    "DOTA2",
    "LOL",
    "CODM",
    "WILDRIFT"
  ];
  String _selectedGame = "MLBB";

  final TextEditingController _minPlayersController = TextEditingController();
  final TextEditingController _maxPlayersController = TextEditingController();
  final TextEditingController _participantsLimitController =
      TextEditingController();
  final TextEditingController _challongLinkController = TextEditingController();
  final TextEditingController _specificLocationController =
      TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactDetailsController =
      TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _prizeController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();

  String _registrationLimit = "Unlimited";
  String _registrationLocation = "All of Cebu";
  String _specificSpecification = "School";
  String _specificTown = "Naga";

  final List<String> _towns = ["Naga", "Minglanilla", "Basak"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Setup'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                ),
              ),
              DropdownButton<String>(
                value: _selectedGame,
                hint: Text("Select Game"),
                isExpanded: true,
                items: _games.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Nullable String
                  setState(() {
                    _selectedGame = newValue!;
                  });
                },
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                ),
              ),
              TextField(
                controller: _contactDetailsController,
                decoration: InputDecoration(
                  labelText: 'Contact Details',
                ),
              ),
              TextField(
                controller: _rulesController,
                decoration: InputDecoration(
                  labelText: 'Rules',
                ),
              ),
              TextField(
                controller: _prizeController,
                decoration: InputDecoration(
                  labelText: 'Prize',
                ),
              ),
              TextField(
                controller: _scheduleController,
                decoration: InputDecoration(
                  labelText: 'Schedule',
                ),
              ),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextField(
                controller: _minPlayersController,
                decoration: InputDecoration(
                  labelText: 'Min Players Per Team',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _maxPlayersController,
                decoration: InputDecoration(
                  labelText: 'Max Players Per Team',
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _registrationLimit,
                isExpanded: true,
                items: ["Unlimited", "Limited"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _registrationLimit = newValue!;
                    if (_registrationLimit == "Unlimited") {
                      _participantsLimitController.text = "";
                    }
                  });
                },
              ),
              if (_registrationLimit == "Limited")
                TextField(
                  controller: _participantsLimitController,
                  decoration: InputDecoration(
                    labelText: 'Participants Limit',
                  ),
                  keyboardType: TextInputType.number,
                ),
              TextField(
                controller: _challongLinkController,
                decoration: InputDecoration(
                  labelText: 'Enter Challong Link',
                ),
              ),
              DropdownButton<String>(
                value: _registrationLocation,
                isExpanded: true,
                items: ["All of Cebu", "Specific"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _registrationLocation = newValue!;
                    if (_registrationLocation == "All of Cebu") {
                      _specificLocationController.text = "";
                    }
                  });
                },
              ),
              if (_registrationLocation == "Specific") ...[
                DropdownButton<String>(
                  value: _specificSpecification,
                  isExpanded: true,
                  items: ["School", "Town"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _specificSpecification = newValue!;
                    });
                  },
                ),
                if (_specificSpecification == "Town") ...[
                  DropdownButton<String>(
                    value: _specificTown,
                    isExpanded: true,
                    items: _towns.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _specificTown = newValue!;
                      });
                    },
                  ),
                ]
              ],
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Event newEvent = Event(
            eventName: _eventNameController.text,
            game: _selectedGame,
            description: _descriptionController.text,
            contactDetails: _contactDetailsController.text,
            rules: _rulesController.text,
            prize: _prizeController.text,
            schedule: _scheduleController.text,
            minPlayers: _minPlayersController.text,
            maxPlayers: _maxPlayersController.text,
            registrationLimit: _registrationLimit,
            participantsLimit: _participantsLimitController.text,
            challongLink: _challongLinkController.text,
            registrationLocation: _registrationLocation,
            specificSpecification: _specificSpecification,
            specificTown: _specificTown,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventScreen(event: newEvent),
            ),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
