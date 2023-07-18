// class TeamDetailCard extends StatelessWidget {
//   final Team team;

//   const TeamDetailCard({required this.team});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Team ID: ${team.teamId}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text('Team Name: ${team.teamName}'),
//             Text('Manager: ${team.manager['username']}'),
//             Text('Game: ${team.game}'),
//             Text('Members: ${team.members?.toString() ?? 'None'}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
