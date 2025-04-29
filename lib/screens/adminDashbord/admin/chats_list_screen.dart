import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/screens/adminDashbord/chat.dart';
import 'chat_screen.dart';  // تأكد من استيراد صفحة الشات هنا

class ChatsListScreen extends StatefulWidget {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final DatabaseReference _chatsRef =
      FirebaseDatabase.instance.ref().child('Chats');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: StreamBuilder(
        stream: _chatsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.snapshot.value != null &&
              snapshot.data!.snapshot.value is Map) {
            final chatsMap =
                Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
            final chats = chatsMap.entries.map((entry) {
              final userId = entry.key;
              final messagesMap = entry.value['messages'];
              if (messagesMap != null && messagesMap is Map) {
                final messages = Map<String, dynamic>.from(messagesMap);
                final lastEntry = messages.entries.last;
                final lastValue = lastEntry.value;

                String lastText = '';
                if (lastValue is Map && lastValue.containsKey('text')) {
                  lastText = lastValue['text'];
                }

                return {
                  'userId': userId,
                  'lastMessage': lastText,
                };
              } else {
                return {
                  'userId': userId,
                  'lastMessage': '',
                };
              }
            }).toList();

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  title: Text('User: ${chat['userId']}'),
                  subtitle: Text('Last message: ${chat['lastMessage']}'),
                  onTap: () {
                    // انتقل إلى صفحة الشات عندما تضغط على أحد العناصر
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(userId: chat['userId'], otherUserEmail: '',),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No chats found.'));
          }
        },
      ),
    );
  }
}
