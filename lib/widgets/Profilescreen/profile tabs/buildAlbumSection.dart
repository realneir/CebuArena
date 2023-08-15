import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AlbumSection extends StatefulWidget {
  @override
  _AlbumSectionState createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  final picker = ImagePicker();

  late CollectionReference albumRef;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      albumRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('album');
    } else {
      print('No user is logged in');
      albumRef = FirebaseFirestore.instance
          .collection('users')
          .doc('')
          .collection('album'); 
    }
  }

  Future<void> pickImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in');
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid)
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
          onPressed: FirebaseAuth.instance.currentUser != null
              ? pickImage
              : null, 
          child: Text('Upload'),
        ),
        SizedBox(height: 10), 
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: albumRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); 
              }
              if (snapshot.hasError) {
                return Text('Something went wrong'); 
              }
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Container(
                          child: Image.network(
                            doc['url'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteImage(doc),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: InteractiveViewer(
                                child: Image.network(doc['url']),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return Text('No images found'); 
              }
            },
          ),
        ),
      ],
    );
  }
}
