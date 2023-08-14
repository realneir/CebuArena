import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AlbumSection extends StatefulWidget {
  @override
  _AlbumSectionState createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  final picker = ImagePicker();
  final CollectionReference albumRef = FirebaseFirestore.instance.collection('album');
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://cebuarena-database.appspot.com');

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = _storage
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
    final ref = _storage.refFromURL(doc['url']);
    await ref.delete();
    await doc.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: pickImage,
          child: Text('Upload Image'),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: albumRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return ListTile(
                      leading: Image.network(doc['url']),
                      title: Text('Image'),
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
