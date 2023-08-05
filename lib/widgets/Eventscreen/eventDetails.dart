import 'package:captsone_ui/services/EventsProvider/eventsProvider.dart';
import 'package:captsone_ui/services/EventsProvider/fetchEvents.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createEventProvider = Provider.autoDispose<CreateEvent>((ref) {
  final userDetails = ref.read(userDetailsProvider);
  return CreateEvent(userDetails);
});

// ignore: must_be_immutable
class EventCreationScreen extends ConsumerWidget {
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final rulesController = TextEditingController();
  final prizesController = TextEditingController();
  final maximumTeamsController = TextEditingController();
  final eventTimeController = TextEditingController();

  String selectedGame = "Select Game";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final games = ["MLBB", "DOTA2", "CODM", "VALORANT", "LOL", "WILDRIFT"];

  EventCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Create Event'),
            backgroundColor: Colors.grey,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedGame,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGame = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Game',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      items: ["Select Game", ...games]
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(eventNameController, 'Event Name'),
                  SizedBox(height: 16),
                  _buildTextField(
                      eventDescriptionController, 'Event Description',
                      maxLines: 5),
                  SizedBox(height: 16),
                  _buildTextField(rulesController, 'Rules'),
                  SizedBox(height: 16),
                  _buildTextField(prizesController, 'Prizes'),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<int>(
                      value: maximumTeamsController.text.isNotEmpty
                          ? int.parse(maximumTeamsController.text)
                          : 1,
                      onChanged: (int? newValue) {
                        setState(() {
                          maximumTeamsController.text = newValue.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Maximum Teams',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      items: List.generate(
                        30,
                        (index) => DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text((index + 1).toString()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDatePicker(context, setState),
                  SizedBox(height: 16),
                  _buildTimePicker(context, setState),
                  SizedBox(height: 16),
                  _buildCreateEventButton(context, ref),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextField _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  ElevatedButton _buildDatePicker(BuildContext context, StateSetter setState) {
    return ElevatedButton(
      onPressed: () async {
        selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        setState(() {});
      },
      child: Text('Pick Date'),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
    );
  }

  ElevatedButton _buildTimePicker(BuildContext context, StateSetter setState) {
    return ElevatedButton(
      onPressed: () async {
        selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        setState(() {});
      },
      child: Text('Pick Time'),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
    );
  }

  ElevatedButton _buildCreateEventButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final container = ref.read(createEventProvider);
        final result = await container.createEvent(
          eventName: eventNameController.text,
          selectedGame: selectedGame == "Select Game" ? null : selectedGame,
          eventDescription: eventDescriptionController.text,
          rules: rulesController.text,
          prizes: prizesController.text,
          maximumTeams: int.parse(maximumTeamsController.text),
          selectedDate: selectedDate!,
          selectedTime: selectedTime!,
        );
        if (result == 'Event created successfully') {
          ref.read(eventsProvider.notifier).refreshEvents();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
        Navigator.of(context).pop();
      },
      child: Text('Create Event'),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
    );
  }
}
