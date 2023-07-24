import 'package:captsone_ui/services/EventsProvider/eventsProvider.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your createEventProvider
final createEventProvider = Provider.autoDispose<CreateEvent>((ref) {
  // Fetch the UserDetailsProvider instance from the provider container
  final userDetails = ref.read(userDetailsProvider);

  // Provide the UserDetailsProvider to the CreateEvent provider
  return CreateEvent(userDetails);
});

class EventCreationScreen extends ConsumerWidget {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController prizesController = TextEditingController();
  final TextEditingController maximumTeamsController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();

  String selectedGame = "Select Game"; // Store the selected game
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> games = [
    "MLBB",
    "DOTA2",
    "CODM",
    "VALORANT",
    "LOL",
    "WILDRIFT",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Create Event'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Game selection dropdown
                  DropdownButton<String>(
                    value: selectedGame,
                    onChanged: (String? newValue) {
                      // Update the selected game when the user makes a selection
                      setState(() {
                        selectedGame = newValue!;
                      });
                    },
                    items: [
                      // Add a default dropdown item with the text "Select Game"
                      DropdownMenuItem<String>(
                        value: "Select Game",
                        child: Text('Select Game'),
                      ),
                      // Add the actual games from the games list
                      ...games.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Event name input
                  TextFormField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Event description input
                  TextFormField(
                    controller: eventDescriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Event Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Other event inputs (rules, prizes, maximum teams, date, time, etc.)
                  TextFormField(
                    controller: rulesController,
                    decoration: InputDecoration(
                      labelText: 'Rules',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: prizesController,
                    decoration: InputDecoration(
                      labelText: 'Prizes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: maximumTeamsController.text.isNotEmpty
                        ? int.parse(maximumTeamsController.text)
                        : 1,
                    onChanged: (int? newValue) {
                      setState(() {
                        maximumTeamsController.text = newValue.toString();
                      });
                    },
                    items: List.generate(
                      30,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Maximum Teams',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      setState(
                          () {}); // Update the UI after the date is selected
                    },
                    child: const Text('Pick Date'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () async {
                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(
                          () {}); // Update the UI after the time is selected
                    },
                    child: const Text('Pick Time'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final container = ref.read(createEventProvider);
                      // Get the event data from the input fields
                      final result = await container.createEvent(
                        eventName: eventNameController.text,
                        selectedGame:
                            selectedGame == "Select Game" ? null : selectedGame,
                        eventDescription: eventDescriptionController.text,
                        rules: rulesController.text,
                        prizes: prizesController.text,
                        maximumTeams: int.parse(maximumTeamsController.text),
                        selectedDate: selectedDate!,
                        selectedTime: selectedTime!,
                      );

                      // Handle the result as per your requirement (e.g., show a snackbar)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      );
                    },
                    child: Text('Create Event'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
