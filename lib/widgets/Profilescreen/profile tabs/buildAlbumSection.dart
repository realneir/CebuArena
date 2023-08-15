import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AlbumSection extends StatefulWidget {
  @override
  _AlbumSectionState createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  final picker = ImagePicker();
  final CollectionReference albumRef =
      FirebaseFirestore.instance.collection('album');

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('files')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();

      albumRef.add({
        'url': url,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  Future<void> deleteImage(DocumentSnapshot doc) async {
    final ref = FirebaseStorage.instance.refFromURL(doc['url']);
    await ref.delete();
    await doc.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: pickImage,
          child: Text('Upload'),
        ),
        SizedBox(height: 10), // Spacing below the button
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: albumRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return Container(
                      height: 1000, // Adjust the height of the ListTile
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Image.network(
                          doc['url'],
                          height: 1000, // Adjust the height of the preview
                          width: 1000, // Adjust the width of the preview
                          fit: BoxFit.cover, // Make sure the image covers the entire space
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteImage(doc),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Image.network(doc['url']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
