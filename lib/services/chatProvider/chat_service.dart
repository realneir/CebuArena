import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  Future<Future<DocumentReference<Map<String, dynamic>>>> sendMessage(
      String chatId, String message, String localId) async {
    return chatCollection.doc(chatId).collection('messages').add({
      'message': message,
      'sentBy': localId,
      'sentAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMessageStream(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots();
  }
}
