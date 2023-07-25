import 'package:captsone_ui/services/chatProvider/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:captsone_ui/services/authenticationProvider/auth_provider.dart';
import 'package:captsone_ui/Screens/navbar/messages/chat_page.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final ChatService _chatService = ChatService();
  late Future<List<DocumentSnapshot>> interactedUsersFuture =
      Future.value([]); //initialize with a dummy value
  String userId = "";

  @override
  void initState() {
    super.initState();
    getCurrentUserId().then((id) {
      if (id != null) {
        setState(() {
          userId = id;
          interactedUsersFuture = _chatService.getInteractedUsers(userId);
        });
      }
    });
  }

  Future<String?> getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Inbox', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue[400],
          elevation: 0,
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: interactedUsersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final chat = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/teamProfile.jpg'),
                        radius: 25,
                      ),
                      title: Text(
                        chat.get('lastMessageSentByName'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.get('lastMessage'),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              userId: chat.get('lastMessageSentTo'),
                              username: chat.get('lastMessageSentByName'),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
