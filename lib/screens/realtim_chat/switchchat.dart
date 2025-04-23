import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class TestChatScreen extends StatefulWidget {
  const TestChatScreen({Key? key}) : super(key: key);
  static const String id = 'test_chat_screen';

  @override
  State<TestChatScreen> createState() => _TestChatScreenState();
}

class _TestChatScreenState extends State<TestChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // IDs
  final String userEmail = 'user1@test.com';
  final String adminEmail = 'admin@test.com';
  bool isAdmin = false;

  late String currentUserEmail;
  late String otherUserEmail;
  late DatabaseReference _chatRef;

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  void _setupChat() {
    currentUserEmail = isAdmin ? adminEmail : userEmail;
    otherUserEmail = isAdmin ? userEmail : adminEmail;
    String chatId = getChatId(userEmail, adminEmail);
    _chatRef = FirebaseDatabase.instance.ref().child('Chats').child(chatId).child('messages');
    setState(() {}); // Refresh the UI
  }

  String getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0].replaceAll('.', '_')}_${sorted[1].replaceAll('.', '_')}';
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatRef.push().set({
        'text': message,
        'sender': currentUserEmail,
        'receiver': otherUserEmail,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Admin Chat' : 'User Chat' , style: const TextStyle(color: ColorsUtility.messageSenderColor),),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Switch Role',
            onPressed: () {
              setState(() {
                isAdmin = !isAdmin;
                _setupChat();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _chatRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
                  List sortedMessages = data.entries
                      .map((e) => e.value)
                      .toList()
                    ..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                  return ListView.builder(
                    itemCount: sortedMessages.length,
                    itemBuilder: (context, index) {
                      final message = sortedMessages[index];
                      final isMe = message['sender'] == currentUserEmail;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message['sender'] ?? '',
                                style: const TextStyle(fontSize: 10, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No messages yet'));
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
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(),
                      filled: true,
                      // fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
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
