import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessageToServer(String message) async {
    final url = Uri.parse('http://192.168.1.1:8000');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _messages.add(ChatMessage(
            text: responseData['response'],
            isUser: false,
          ));
        });
      } else {
        // Handle error response
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
        setState(() {
          _messages.add(ChatMessage(
            text: messageText,
            isUser: true,
          ));
        });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text;

    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isUser: true,
      ));
      _messageController.clear();
      _scrollToBottom();
    });
    _sendMessageToServer(messageText);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue.shade700 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey.shade800,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}