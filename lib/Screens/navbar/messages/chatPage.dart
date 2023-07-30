import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:captsone_ui/services/authenticationProvider/authProvider.dart';
import 'package:captsone_ui/services/chatProvider/chatService.dart';
import 'package:intl/intl.dart';

class ChatPage extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();
  final String userId;
  final String username;
  final ScrollController _scrollController = ScrollController();

  ChatPage({required this.userId, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('userId: $userId');
    print('username: $username');
    final userDetails = ref.watch(userDetailsProvider);
    final chatService = ref.watch(chatServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $username',
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[300],
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: userDetails.localId != null
                  ? chatService.getMessageStream(userDetails.localId!, userId)
                  : null,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  Future.delayed(Duration.zero, () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String sentByName = data['sentByName'] as String? ?? '';
                    String firstname = userDetails.firstname ?? '';
                    Timestamp timestamp =
                        data['sentAt'] as Timestamp? ?? Timestamp.now();
                    DateTime date = timestamp.toDate();

                    String timeText = DateFormat('hh:mm a').format(date);

                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: (sentByName == firstname
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (sentByName == firstname
                                ? Colors.blueAccent
                                : Colors.grey[300]),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sentByName == firstname ? 'You' : sentByName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: sentByName == firstname
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data['message'],
                                style: TextStyle(
                                  color: sentByName == firstname
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timeText,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: sentByName == firstname
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Write message...",
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      String localId = userDetails.localId ?? '';
                      String firstname = userDetails.firstname ?? '';
                      if (localId.isNotEmpty && firstname.isNotEmpty) {
                        chatService.sendMessage(
                          localId,
                          userId,
                          _controller.text,
                          firstname,
                          username,
                        );
                        _controller.clear();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      }
                    }
                  },
                  child: const Icon(Icons.send, color: Colors.white),
                  backgroundColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
