import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AboutSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider);

    TextEditingController firstNameController = TextEditingController(text: user.firstname);
    TextEditingController lastNameController = TextEditingController(text: user.lastname);
    TextEditingController emailController = TextEditingController(text: user.email);
    // TextEditingController phoneController = TextEditingController(text: user.contactNumber);

    Future<void> updateDetails() async {
      await user.updateDetails(
        firstname: firstNameController.text,
        lastname: lastNameController.text,
        email: emailController.text,
        // phone: phoneController.text,
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // TextFormField(
            //   
            //   controller: phoneController,
            //   decoration: InputDecoration(labelText: 'Phone'),
            //   keyboardType: TextInputType.phone,
            // ),
            // ElevatedButton(
            //   onPressed: updateDetails,
            //   child: Text('Update'),
            // ),
          ],
        ),
      ),
    );
  }
}
