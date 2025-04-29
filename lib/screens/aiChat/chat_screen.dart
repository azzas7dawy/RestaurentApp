import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/aiChat/typing_indicator_widget.dart';
import 'package:universal_html/html.dart' as html
    if (dart.library.io) 'dart:io';
import 'package:path/path.dart' as path;
import 'package:pdf_text/pdf_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final String _apiKey =
      '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';
  bool _isTyping = false;
  dynamic _selectedImage;
  dynamic _selectedFile;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        if (kIsWeb) {
          final bytes = result.files.first.bytes;
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          setState(() {
            _selectedImage = url;
          });
        } else {
          setState(() {
            _selectedImage = File(result.files.single.path!);
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(S.of(context).noImgSelected),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).failedToPickImg}: $e'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        if (kIsWeb) {
          setState(() {
            _selectedFile = {
              'name': result.files.first.name,
              'bytes': result.files.first.bytes,
            };
          });
        } else {
          setState(() {
            _selectedFile = {
              'file': File(result.files.single.path!),
              'name': result.files.first.name,
            };
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(S.of(context).noFileSelected),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).failedToPickFile}: $e'),
          ),
        );
      }
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty &&
        _selectedImage == null &&
        _selectedFile == null) {
      return;
    }

    if (_selectedImage != null) {
      await _handleImageMessage();
    } else if (_selectedFile != null) {
      await _handleFileMessage();
    } else {
      await _handleTextMessage();
    }
  }

  Future<void> _handleImageMessage() async {
    final userMessage = _controller.text.isNotEmpty
        ? _controller.text
        : "What's in this image?";
    _controller.clear();

    setState(() {
      _messages.add({
        'sender': 'user',
        'type': 'image',
        'content': _selectedImage,
        'isWeb': kIsWeb,
      });
      if (userMessage.isNotEmpty) {
        _messages.add({
          'sender': 'user',
          'type': 'text',
          'content': userMessage,
        });
      }
      _isTyping = true;
    });

    final aiResponse = await _generateAIResponseWithImage(
      userMessage,
      _selectedImage,
    );

    setState(() {
      _isTyping = false;
      _messages.add({'sender': 'ai', 'type': 'text', 'content': aiResponse});
      _selectedImage = null;
    });
  }

  Future<void> _handleFileMessage() async {
    final userMessage = _controller.text.isNotEmpty
        ? _controller.text
        : "Please analyze this file";
    _controller.clear();

    setState(() {
      _messages.add({
        'sender': 'user',
        'type': 'file',
        'content': _selectedFile,
        'isWeb': kIsWeb,
      });
      if (userMessage.isNotEmpty) {
        _messages.add({
          'sender': 'user',
          'type': 'text',
          'content': userMessage,
        });
      }
      _isTyping = true;
    });

    final aiResponse = await _analyzeFileContent(userMessage);

    setState(() {
      _isTyping = false;
      _messages.add({'sender': 'ai', 'type': 'text', 'content': aiResponse});
      _selectedFile = null;
    });
  }

  Future<void> _handleTextMessage() async {
    final userMessage = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({'sender': 'user', 'type': 'text', 'content': userMessage});
      _isTyping = true;
    });

    final aiResponse = await _generateAIResponse(userMessage);

    setState(() {
      _isTyping = false;
      _messages.add({'sender': 'ai', 'type': 'text', 'content': aiResponse});
    });
  }

  Future<String> _generateAIResponse(String userMessage) async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: Failed to connect to the AI service.';
    }
  }

  Future<String> _generateAIResponseWithImage(
    String userMessage,
    dynamic image,
  ) async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      String base64Image;
      if (kIsWeb) {
        final response = await http.get(Uri.parse(image));
        base64Image = base64Encode(response.bodyBytes);
      } else {
        final imageBytes = await (image as File).readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': userMessage},
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
              ],
            },
          ],
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: Failed to connect to the AI service.';
    }
  }

  Future<String> _analyzeFileContent(String userMessage) async {
    try {
      String fileContent;
      final fileName = _selectedFile['name'];
      final fileExtension = path.extension(fileName).toLowerCase();

      if (fileExtension == '.pdf') {
        if (kIsWeb) {
          return 'Error: PDF text extraction is not supported on web. Please use the mobile app.';
        } else {
          final file = _selectedFile['file'] as File;
          final pdfDoc = await PDFDoc.fromFile(file);
          fileContent = await pdfDoc.text;
        }
      } else {
        if (kIsWeb) {
          final bytes = _selectedFile['bytes'];
          fileContent = utf8.decode(bytes);
        } else {
          final file = _selectedFile['file'] as File;
          fileContent = await file.readAsString();
        }
      }

      return await _generateAIResponse(
        '$userMessage\n\nFile content:\n$fileContent',
      );
    } catch (e) {
      return 'Error: Could not read the file content. Please make sure the file is in a supported format (PDF, Word, Excel, or plain text). Error details: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).bot,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'user';

                  if (message['type'] == 'image') {
                    return _buildImageMessage(message, isUser, theme);
                  } else if (message['type'] == 'file') {
                    return _buildFileMessage(message, isUser, theme);
                  } else {
                    return _buildTextMessage(message, isUser, theme);
                  }
                } else {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: TypingIndicatorWidget(),
                    ),
                  );
                }
              },
            ),
          ),
          if (_selectedImage != null || _selectedFile != null)
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  _selectedImage != null
                      ? _buildSelectedImagePreview(theme)
                      : _buildSelectedFilePreview(theme),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                          _selectedFile = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: theme.colorScheme.onError,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                IconButton(
                  icon:
                      Icon(Icons.attach_file, color: theme.colorScheme.primary),
                  onPressed: _pickFile,
                ),
                IconButton(
                  icon: Icon(Icons.image, color: theme.colorScheme.primary),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: S.of(context).typeYourMsg,
                      hintStyle: theme.inputDecorationTheme.hintStyle,
                      border: theme.inputDecorationTheme.border,
                      focusedBorder: theme.inputDecorationTheme.focusedBorder,
                      filled: theme.inputDecorationTheme.filled,
                      fillColor: theme.inputDecorationTheme.fillColor,
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(
      Map<String, dynamic> message, bool isUser, ThemeData theme) {
    final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: kIsWeb
              ? Image.network(
                  message['content'],
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  message['content'] as File,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _buildFileMessage(
      Map<String, dynamic> message, bool isUser, ThemeData theme) {
    final fileName = message['content']['name'];
    final fileExtension = path.extension(fileName).toLowerCase();

    IconData fileIcon;
    if (fileExtension == '.pdf') {
      fileIcon = Icons.picture_as_pdf;
    } else if (fileExtension == '.doc' || fileExtension == '.docx') {
      fileIcon = Icons.description;
    } else if (fileExtension == '.xls' || fileExtension == '.xlsx') {
      fileIcon = Icons.table_chart;
    } else if (fileExtension == '.txt') {
      fileIcon = Icons.text_fields;
    } else {
      fileIcon = Icons.insert_drive_file;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(fileIcon, color: theme.iconTheme.color),
            const SizedBox(width: 8),
            Text(
              fileName,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextMessage(
      Map<String, dynamic> message, bool isUser, ThemeData theme) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message['content'] as String,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: kIsWeb
          ? Image.network(
              _selectedImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          : Image.file(
              _selectedImage as File,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildSelectedFilePreview(ThemeData theme) {
    final fileName = _selectedFile['name'];
    final fileExtension = path.extension(fileName).toLowerCase();

    IconData fileIcon;
    if (fileExtension == '.pdf') {
      fileIcon = Icons.picture_as_pdf;
    } else if (fileExtension == '.doc' || fileExtension == '.docx') {
      fileIcon = Icons.description;
    } else if (fileExtension == '.xls' || fileExtension == '.xlsx') {
      fileIcon = Icons.table_chart;
    } else if (fileExtension == '.txt') {
      fileIcon = Icons.text_fields;
    } else {
      fileIcon = Icons.insert_drive_file;
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            fileIcon,
            size: 40,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            fileName.length > 15
                ? '${fileName.substring(0, 12)}...$fileExtension'
                : fileName,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
