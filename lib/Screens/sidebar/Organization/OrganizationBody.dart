import 'dart:convert';
import 'package:captsone_ui/Screens/sidebar/Organization/orgWidgets.dart';
import 'package:captsone_ui/services/Organization/org.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final organizationInfoProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final userDetails = ref.read(userDetailsProvider);
  final organizationInfo = GetOrganizationInfo(userDetails);
  return organizationInfo.fetchOrganizationInfo();
});

class orgBody extends ConsumerWidget {
  final double coverHeight;
  final double profileHeight;

  const orgBody({
    required this.coverHeight,
    required this.profileHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationInfoAsyncValue = ref.watch(organizationInfoProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: coverHeight,
              child: buildCoverPhoto(coverHeight),
            ),
            Positioned(
              left: 20,
              top: coverHeight - (profileHeight / 1.5),
              child: buildProfilePhoto(profileHeight),
            ),
            Positioned(
              left: 20,
              top: coverHeight - (profileHeight / 1.3) + profileHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column 1 - Organization Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      organizationInfoAsyncValue.when(
                        data: (data) {
                          final orgName = data['org_name'];
                          return buildTextWithPadding(
                            '$orgName',
                            20,
                            FontWeight.bold,
                          );
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (error, _) => Text('Error: $error'),
                      ),
                      organizationInfoAsyncValue.when(
                        data: (data) {
                          final ownerFirstname = data['owner']['firstname'];
                          final ownerLastname = data['owner']['lastname'];
                          return buildTextWithPadding(
                            '@$ownerFirstname $ownerLastname',
                            14,
                            FontWeight.normal,
                          );
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (error, _) => Text('Error: $error'),
                      ),
                    ],
                  ),
                  // ... Rest of the code ...
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
