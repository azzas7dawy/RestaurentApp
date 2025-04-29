import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
class ChatScreenn extends StatefulWidget {
  final String userId; // ID المستخدم الآخر

  ChatScreenn({required this.userId, required myId, required String otherId});

  @override
  _ChatScreennState createState() => _ChatScreennState();
}

class _ChatScreennState extends State<ChatScreenn> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messagesList = [];
  bool isSending = false;
  String myId = '';
  String otherUserEmail = '';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      myId = user.uid;
      otherUserEmail = user.email ?? '';
      listenToMessages();
    } else {
      // المستخدم غير مسجل دخول
      print('No user signed in');
    }
  }

  void listenToMessages() {
    dbRef.child('Chats').child(widget.userId).child('messages').onValue.listen(
      (event) {
        final data = event.snapshot.value as Map?;
        if (data != null) {
          List<Map<String, dynamic>> temp = [];
          data.forEach((key, value) {
            final msg = Map<String, dynamic>.from(value);
            msg['id'] = key;
            temp.add(msg);
          });

          temp.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

          setState(() {
            messagesList = temp;
          });

          markMessagesAsRead(temp);
          Future.delayed(Duration(milliseconds: 100), () {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });
        } else {
          setState(() {
            messagesList = [];
          });
        }
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load messages')));
      },
    );
  }

  void markMessagesAsRead(List<Map<String, dynamic>> msgs) {
    final messagesRef = dbRef.child('Chats').child(widget.userId).child('messages');
    for (var msg in msgs) {
      if (msg['sender'] != myId && msg['read'] == false) {
        messagesRef.child(msg['id']).update({'read': true});
      }
    }
  }

  void sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isSending = true;
    });

    final messageId = dbRef.child('Chats').child(widget.userId).child('messages').push().key;
    final messageData = {
      'message': text,
      'sender': myId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'read': false,
    };

    dbRef.child('Chats').child(widget.userId).child('messages').child(messageId!).set(messageData);
    _messageController.clear();

    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() {
        isSending = false;
      });
    });
  }

  String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('hh:mm a').format(date);
  }

  Widget buildReadStatus(bool isMe, bool read) {
    if (!isMe) return SizedBox.shrink();
    return Icon(
      read ? Icons.done_all : Icons.check,
      size: 16,
      color: read ? Colors.blue : Colors.black54,
    );
  }

  Widget buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? const Color.fromARGB(255, 117, 51, 31) : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg['message'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatTimestamp(msg['timestamp']),
                  style: TextStyle(fontSize: 10, color: const Color.fromARGB(137, 202, 115, 115)),
                ),
                SizedBox(width: 5),
                buildReadStatus(isMe, msg['read']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otherUserEmail.isNotEmpty ? otherUserEmail : 'Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messagesList.length,
              itemBuilder: (context, index) {
                final msg = messagesList[index];
                final isMe = msg['sender'] == myId;
                return buildMessageBubble(msg, isMe);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message...' , hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                IconButton(
                  icon: Icon(isSending ? Icons.access_time : Icons.send),
                  onPressed: isSending ? null : sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
