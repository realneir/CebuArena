import 'package:captsone_ui/Screens/sidebar/Organization/OrganizationBody.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class orgDescription extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationInfo = ref.watch(organizationInfoProvider);

    return Card(
      elevation: 2, // Add elevation for a card-like appearance
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: organizationInfo.when(
          data: (data) {
            final orgDescription = data['org_description'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  orgDescription,
                  textAlign: TextAlign.justify,
                ),
              ],
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (error, _) => Text('Error: $error'),
        ),
      ),
    );
  }
}
