import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:captsone_ui/services/scrim.dart';

class ScrimmageDetails extends StatefulWidget {
  @override
  _ScrimmageDetailsState createState() => _ScrimmageDetailsState();
}

class _ScrimmageDetailsState extends State<ScrimmageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrimmage Details'),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.white24,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
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
                  child: Text(value, style: TextStyle(color: Colors.black)),
                );
              }).toList(),
              dropdownColor: Colors.grey[200],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[200],
                onPrimary: Colors.black,
              ),
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
            SizedBox(height: 16.0),
            Text(
              "Selected date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[200],
                onPrimary: Colors.black,
              ),
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
            SizedBox(height: 16.0),
            Text(
              "Selected time: ${selectedTime.format(context)}",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  preferences = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Enter your preferences",
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  contactDetails = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Enter your contact details",
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              onPressed: () => createScrimmage(context),
              child: Text('Set'),
            ),
          ],
        ),
      ),
    );
  }
}
