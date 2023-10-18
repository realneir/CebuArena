import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinEventProvider {
  static Future<void> joinEvent(String eventId, String localId) async {
    final url = Uri.parse('http://10.0.2.2:8000/join_event/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'event_id': eventId,
          'localId': localId,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully joined the event
        print('Joined event successfully.');
      } else {
        // Handle specific error cases
        if (response.statusCode == 400) {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['error_message'];
          throw Exception('Failed to join event: $errorMessage');
        } else {
          throw Exception(
              'Failed to join event with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle other errors
      throw Exception('Error joining event: $e');
    }
  }
}
