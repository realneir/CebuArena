import 'package:captsone_ui/services/chatProvider/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:captsone_ui/Screens/navbar/messages/chat_page.dart';
import 'package:google_fonts/google_fonts.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final ChatService _chatService = ChatService();
  late Future<List<Map<String, dynamic>>> interactedUsersFuture =
      Future.value([]);
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
          backgroundColor: Colors.grey[300],
          title: Text(
            'Messages',
            style: GoogleFonts.orbitron(
              color: Colors.black,
              fontSize: 24,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
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
                  final chatInfo = snapshot.data![index];
                  final chatDoc = chatInfo['chatDoc'];
                  final receiverName = chatInfo['receiverName'];

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/teamProfile.jpg'),
                        radius: 25,
                      ),
                      title: Text(
                        '$receiverName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatDoc['lastMessage'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              userId: (chatDoc['lastMessageSentBy'] == userId)
                                  ? chatDoc['lastMessageSentTo']
                                  : chatDoc['lastMessageSentBy'],
                              username: receiverName,
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
