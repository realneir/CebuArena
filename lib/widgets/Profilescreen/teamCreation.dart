// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<void> createTeam(String teamName, String game, String managerId) async {
//   const apiUrl =
//       'http://127.0.0.1:8000/create_team/'; // Replace with your actual API endpoint

//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: json.encode({
//         'team_name': teamName,
//         'game': game,
//       }),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       // Team created successfully
//       final responseData = json.decode(response.body);
//       final message = responseData['message'];
//       print(message);
//     } else {
//       // Error handling for unsuccessful response
//       final responseData = json.decode(response.body);
//       final errorMessage = responseData['error_message'];
//       print(errorMessage);
//     }
//   } catch (e) {
//     // Error handling for exceptions
//     print('Error: $e');
//   }
// }
