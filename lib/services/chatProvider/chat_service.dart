import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentReference<Map<String, dynamic>>> sendMessage(
      String senderId,
      String receiverId,
      String message,
      String firstname,
      String username) async {
    String chatId = senderId.compareTo(receiverId) > 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';

    final messageDocRef =
        await chatCollection.doc(chatId).collection('messages').add({
      'message': message,
      'sentBy': senderId,
      'sentByName': firstname,
      'sentTo': receiverId,
      'sentAt': Timestamp.now(),
    });

    await chatCollection.doc(chatId).set({
      'lastMessage': message,
      'lastMessageSentBy': senderId,
      'lastMessageSentByName': firstname,
      'lastMessageSentTo': receiverId,
      'lastMessageSentAt': Timestamp.now(),
    }, SetOptions(merge: true));

    return messageDocRef;
  }

  Stream<QuerySnapshot> getMessageStream(String senderId, String receiverId) {
    String chatId = senderId.compareTo(receiverId) > 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';

    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: false) // ordered from oldest to newest
        .snapshots();
  }

  Future<List<DocumentSnapshot>> getInteractedUsers(String userId) async {
    print('Getting interacted users for: $userId'); // add this

    final QuerySnapshot chatDocs = await chatCollection
        .where('lastMessageSentBy', isEqualTo: userId)
        .get();
    print('Chat documents retrieved: ${chatDocs.docs.length}'); // add this

    final QuerySnapshot receivedChats = await chatCollection
        .where('lastMessageSentTo', isEqualTo: userId)
        .get();
    print('Received chats retrieved: ${receivedChats.docs.length}'); // add this

    final allInteractedChatDocs = {...chatDocs.docs, ...receivedChats.docs};
    print(
        'All interacted chat documents: ${allInteractedChatDocs.length}'); // add this

    List<DocumentSnapshot> interactedUsers = [];
    for (var chatDoc in allInteractedChatDocs) {
      interactedUsers.add(chatDoc);
    }

    print('Interacted users retrieved: ${interactedUsers.length}'); // add this
    return interactedUsers;
  }
}
