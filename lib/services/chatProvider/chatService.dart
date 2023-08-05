import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentReference<Map<String, dynamic>>> sendMessage(
      String senderId,
      String receiverId,
      String message,
      String senderFirstname,
      String receiverFirstname) async {
    String chatId = senderId.compareTo(receiverId) > 0
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';

    final messageDocRef =
        await chatCollection.doc(chatId).collection('messages').add({
      'message': message,
      'sentBy': senderId,
      'sentByName': senderFirstname,
      'sentTo': receiverId,
      'sentToName': receiverFirstname, // Add the receiver's name here
      'sentAt': Timestamp.now(),
    });

    await chatCollection.doc(chatId).set({
      'lastMessage': message,
      'lastMessageSentBy': senderId,
      'lastMessageSentByName': senderFirstname,
      'lastMessageSentTo': receiverId,
      'lastMessageSentToName':
          receiverFirstname, // Add the receiver's name here
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

  Future<List<Map<String, dynamic>>> getInteractedUsers(String userId) async {
    print('Getting interacted users for: $userId');

    final QuerySnapshot sentChats = await chatCollection
        .where('lastMessageSentBy', isEqualTo: userId)
        .get();

    final QuerySnapshot receivedChats = await chatCollection
        .where('lastMessageSentTo', isEqualTo: userId)
        .get();

    final allInteractedChatDocs = [...sentChats.docs, ...receivedChats.docs];

    List<Map<String, dynamic>> interactedUsers = [];
    for (var chatDoc in allInteractedChatDocs) {
      String lastMessageSentToId = chatDoc['lastMessageSentTo'];
      String receiverId = lastMessageSentToId == userId
          ? chatDoc['lastMessageSentBy']
          : lastMessageSentToId;

      String receiverName = await getReceiverName(receiverId);

      interactedUsers.add({
        'chatDoc': chatDoc,
        'receiverName': receiverName,
      });
    }

    print('Interacted users retrieved: ${interactedUsers.length}');
    return interactedUsers;
  }

  Future<String> getReceiverName(String receiverId) async {
    final receiverDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    return receiverDoc['firstname'] ?? '';
  }

  Stream<int> getUnreadMessagesCount(String? userId) {
    if (userId == null) {
      return const Stream.empty();
    }
    return chatCollection
        .where('sentTo', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
