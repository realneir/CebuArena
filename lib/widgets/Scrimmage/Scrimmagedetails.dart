import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScrimmageDetails extends StatefulWidget {
  @override
  _ScrimmageDetailsState createState() => _ScrimmageDetailsState();
}

class _ScrimmageDetailsState extends State<ScrimmageDetails> {
  String dropdownValue = 'MLBB';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String preferences = '';
  String contactDetails = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrimmage Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'MLBB',
                'VALORANT',
                'DOTA2',
                'LOL',
                'CODM',
                'WILDRIFT'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2026),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text('Select date'),
            ),
            Text(
              "Selected date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
            ),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null && picked != selectedTime) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: Text('Select time'),
            ),
            Text(
              "Selected time: ${selectedTime.format(context)}",
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  preferences = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Enter your preferences",
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  contactDetails = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Enter your contact details",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Pass back the data
                Navigator.pop(context, {
                  'game': dropdownValue,
                  'date': selectedDate,
                  'time': selectedTime,
                  'preferences': preferences,
                  'contact': contactDetails,
                });
              },
              child: Text('Set'),
            ),
          ],
        ),
      ),
    );
  }
}
