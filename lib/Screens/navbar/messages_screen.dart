import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/services/chatProvider/chat_service.dart';

class ChatPage extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();
  final String chatId = '123'; // Replace with actual chat id

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    final chatService = ref.watch(chatServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getMessageStream(chatId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['message']),
                      subtitle: Text(data['sentBy'] == userDetails.localId
                          ? 'You'
                          : data['sentBy']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          TextField(
            controller: _controller,
          ),
          ElevatedButton(
            onPressed: () {
              print("Button Pressed!");
              if (_controller.text.isNotEmpty) {
                chatService.sendMessage(
                    chatId, _controller.text, userDetails.localId!);
                _controller.clear();
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
