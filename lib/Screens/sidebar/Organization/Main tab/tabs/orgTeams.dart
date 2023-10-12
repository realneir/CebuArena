import 'package:captsone_ui/Screens/managerTeamProfile/teamProfile.dart';
import 'package:captsone_ui/services/Organization/orgTeams.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgTeamsSection extends ConsumerWidget {
  const OrgTeamsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final isManager = userDetails.isManager;
    final isMember = userDetails.isMember;

    // Use the teamsProvider to fetch teams for the organization
    final teamsResponse = ref.watch(teamsProvider);

    return teamsResponse.when(
      data: (data) {
        final Map<String, dynamic> teamsData = data['teams'] != null
            ? data['teams'] as Map<String, dynamic>
            : <String, dynamic>{};

        final List teamList = teamsData.values.toList();

        if (teamList.isEmpty) {
          return const Text('No team data available.');
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              if (isManager) ...[
                // Render content specific to managers
                Text(
                  'Manager-Specific Content',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Add more widgets for manager-specific content
              ],
              if (isMember) ...[
                // Render content specific to members
                Text(
                  'Member-Specific Content',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Add more widgets for member-specific content
              ],
              // Common content for both managers and members
              ...teamList.asMap().entries.map((entry) {
                final index = entry.key;
                final teamData = entry.value;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamProfileScreen(),
                          ),
                        );
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/Slider1.jpg'),
                                  radius: 25,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      teamData['team_name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Manager: ${teamData['manager_username'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index < teamList.length - 1)
                      SizedBox(height: 20), // Add spacing between teams
                  ],
                );
              }),
            ],
          ),
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return Text('Error: $error');
      },
    );
  }
}
