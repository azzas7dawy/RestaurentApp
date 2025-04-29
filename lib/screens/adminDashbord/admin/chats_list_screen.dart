import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:restrant_app/screens/adminDashbord/admin/chat_screen.dart';


class ChatsListScreen extends StatefulWidget {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('chat admin');
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  void fetchChats() {
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, dynamic>> temp = [];
        data.forEach((uid, messages) {
          final msgs = Map<String, dynamic>.from(messages);
          final hasUnread = msgs.values.any((msg) =>
            msg['read'] == false && msg['sender'] != 'adminUID'); 

          final lastMsg = msgs.values.last['message'] ?? '';

          temp.add({
            'uid': uid,
            'hasUnread': hasUnread,
            'lastMessage': lastMsg,
          });
        });

        setState(() {
          users = temp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Chats')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['uid']),
            subtitle: Text(user['lastMessage']),
            trailing: user['hasUnread']
              ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text('!', style: TextStyle(color: Colors.white)),
                )
              : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreenn(myId: 'adminUID', otherId:user['uid'], otherUserEmail: user['uid'],)),
              );
            },
          );
        },
      ),
    );
  }
}
