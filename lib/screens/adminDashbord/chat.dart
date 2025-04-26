import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserEmail; 

  static const String id = 'chat_screen';

  const ChatScreen({super.key, required this.otherUserEmail});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String currentUserEmail = '';
  String senderRole = 'user'; 
  late DatabaseReference _chatRef;


  @override
void initState() {
  super.initState();

  final user = FirebaseAuth.instance.currentUser;
  currentUserEmail = user?.email ?? '';


  if (currentUserEmail == "admin@gmail.com") {
    senderRole = "admin";
  } else {
    senderRole = "me";
  }

  final chatId = getChatId(currentUserEmail, widget.otherUserEmail);
  _chatRef = FirebaseDatabase.instance.ref().child('Chats').child(chatId).child('messages');
}


  String getChatId(String email1, String email2) {
    final sorted = [email1, email2]..sort();
    return '${sorted[0].replaceAll('.', '_')}_${sorted[1].replaceAll('.', '_')}';
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatRef.push().set({
        'text': message,
        'sender': senderRole, // admin or user
        'email': currentUserEmail, // optional for reference
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.otherUserEmail}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  List messages = data.entries.map((e) => e.value).toList()
                    ..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message['email'] == currentUserEmail;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? ColorsUtility.messageSenderColor : ColorsUtility.messageReceiverColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'] ?? '',
                                style: const TextStyle(color: ColorsUtility.onboardingColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message['sender'] ?? '',
                                style: const TextStyle(fontSize: 10, color:ColorsUtility.onboardingColor ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No messages yet.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: ColorsUtility.onboardingColor,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                     
                      
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}