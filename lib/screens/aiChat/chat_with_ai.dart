import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // New: Ping result state
  String _pingResult = '';

  // New: Ping server to test connectivity
  Future<void> _pingServer() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/ping'));
      setState(() {
        if (response.statusCode == 200) {
          _pingResult = 'Ping success: ${response.body}';
        } else {
          _pingResult = 'Ping failed: ${response.statusCode}';
        }
      });
      debugPrint(
          '🔵 Ping status: ${response.statusCode}, body: ${response.body}');
    } catch (e) {
      setState(() {
        _pingResult = 'Ping exception: $e';
      });
      debugPrint('⚠️ Ping exception: $e');
    }
  }

  Future<void> _handleSearch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': query});
      isLoading = true;
      _controller.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    try {
      final conversationHistory = messages
          .map((msg) =>
              '${msg['role'] == 'user' ? 'Human' : 'Assistant'}: ${msg['content']}')
          .join('\n');
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'conversation_history': conversationHistory,
        }),
      );
      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔷 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('🟢 Decoded answer: ${data['answer']}');
        setState(() {
          messages.add({'role': 'assistant', 'content': data['answer']});
        });
      } else {
        debugPrint('🔴 Error body: ${response.body}');
        setState(() {
          messages
              .add({'role': 'assistant', 'content': 'خطأ: ${response.body}'});
        });
      }
    } catch (e) {
      debugPrint('⚠️ Exception: $e');
      setState(() {
        messages
            .add({'role': 'assistant', 'content': 'خطأ: فشل الاتصال بالسيرفر'});
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with AI',
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          // New: Ping button in the AppBar
          IconButton(
            icon: const Icon(Icons.wifi_tethering),
            tooltip: 'Ping Server',
            onPressed: _pingServer,
            color: theme.colorScheme.primary,
          ),
        ],
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // New: Display ping result
          if (_pingResult.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_pingResult),
            ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUser = message['role'] == 'user';
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue[100]
                                  : const Color.fromARGB(255, 7, 5, 119),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message['content']!,
                              style: TextStyle(
                                fontSize: 16,
                                color: isUser ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (isLoading) const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Ask Treski',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon:
                            Icon(Icons.send, color: theme.colorScheme.primary),
                        onPressed: isLoading ? null : _handleSearch,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
