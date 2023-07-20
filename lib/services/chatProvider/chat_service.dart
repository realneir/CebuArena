import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  Future<Future<DocumentReference<Map<String, dynamic>>>> sendMessage(
      String chatId, String message, String localId, String firstname) async {
    return chatCollection.doc(chatId).collection('messages').add({
      'message': message,
      'sentBy': localId,
      'sentByName': firstname, // Adding sent by name
      'sentAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMessageStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }
}
