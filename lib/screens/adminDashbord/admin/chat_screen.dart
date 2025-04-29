import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:restrant_app/generated/l10n.dart';

class ChatScreenn extends StatefulWidget {
  final String myId;
  final String otherId;

  const ChatScreenn(
      {super.key,
      required this.myId,
      required this.otherId,
      required String otherUserEmail});

  @override
  _ChatScreennState createState() => _ChatScreennState();
}

class _ChatScreennState extends State<ChatScreenn> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    markMessagesAsRead();
  }

  void fetchMessages() {
    dbRef.child('chat admin/${widget.otherId}').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, dynamic>> temp = [];
        data.forEach((key, value) {
          temp.add({
            'id': key,
            'message': value['message'],
            'sender': value['sender'],
            'timestamp': value['timestamp'],
          });
        });
        temp.sort(
            (a, b) => a['timestamp'].compareTo(b['timestamp'])); // ترتيب زمني
        setState(() {
          messages = temp;
        });
      }
    });
  }

  void markMessagesAsRead() async {
    final snapshot = await dbRef.child('chat admin/${widget.otherId}').get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        if (value['read'] == false && value['sender'] != widget.otherId) {
          dbRef
              .child('chat admin/${widget.otherId}/$key')
              .update({'read': true});
        }
      });
    }
  }

  void sendMessage() {
    final msg = messageController.text.trim();
    if (msg.isNotEmpty) {
      dbRef.child('chat admin/${widget.otherId}').push().set({
        'message': msg,
        'sender': widget.myId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'read': false,
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Chat with ${widget.otherId}',
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // الجديد يطلع تحت
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMe = msg['sender'] == widget.myId;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe
                          ? theme.colorScheme.primary.withOpacity(0.2)
                          : theme.colorScheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['message'], style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          // Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: S.of(context).typeYourMsg,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
