import 'dart:io';
import 'package:captsone_ui/services/Organization/org.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VerificationScreen extends ConsumerWidget {
  final ImagePicker _picker = ImagePicker();

  VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController orgNameController = TextEditingController();
    final TextEditingController orgDescriptionController =
        TextEditingController();
    XFile? _image;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Verification Screen'),
            backgroundColor: Colors.grey,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(orgNameController, 'Organization Name'),
                  SizedBox(height: 16),
                  _buildTextField(
                      orgDescriptionController, 'Organization Description',
                      maxLines: 8),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _image = pickedFile;
                        });
                      }
                    },
                  ),
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.file(File(_image!.path)),
                    ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      String orgName = orgNameController.text;
                      String orgDescription = orgDescriptionController.text;

                      if (orgName.isNotEmpty &&
                          orgDescription.isNotEmpty &&
                          _image != null) {
                        // TODO: Process the Image and send it along with orgName and orgDescription
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Success'),
                            content: const Text(
                                'Request for Creating organization sent successfully'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                        orgNameController.clear();
                        orgDescriptionController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                  ),
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
}
