import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  Future<DocumentReference<Map<String, dynamic>>> sendMessage(String chatId,
      String message, String localId, String firstname, String username) async {
    final docRef = await chatCollection.doc(chatId).collection('messages').add({
      'message': message,
      'sentBy': localId,
      'sentByName': firstname, // Adding sent by name
      'sentAt': Timestamp.now(),
    });

    // Send a notification or trigger a real-time event to notify the other user about the new message
    // You can use push notifications or WebSocket communication for real-time messaging

    return docRef;
  }

  Stream<QuerySnapshot> getMessageStream(String chatId, String userId) {
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }
}
