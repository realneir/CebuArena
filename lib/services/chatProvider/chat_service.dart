import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  Future<DocumentReference<Map<String, dynamic>>> sendMessage(
      String senderId,
      String receiverId,
      String message,
      String firstname,
      String username) async {
    String chatId = senderId.compareTo(receiverId) > 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';

    final docRef = await chatCollection.doc(chatId).collection('messages').add({
      'message': message,
      'sentBy': senderId,
      'sentByName': firstname,
      'sentAt': Timestamp.now(),
    });

    return docRef;
  }

  Stream<QuerySnapshot> getMessageStream(String senderId, String receiverId) {
    String chatId = senderId.compareTo(receiverId) > 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';

    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }
}
