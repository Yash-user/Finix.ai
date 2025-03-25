import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  
  const ChatPage({
    super.key,
    required this.toggleTheme,
  });

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

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text,
        isUser: true,
      ));
      // Simulate AI response
      _messages.add(ChatMessage(
        text: "I'm your AI assistant. How can I help you today?",
        isUser: false,
      ));
      _messageController.clear();
      _scrollToBottom();
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.blue.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
          const SizedBox(width: 16),
        ],
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
                return _buildMessage(message, isDark);
              },
            ),
          ),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, bool isDark) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser 
              ? (isDark ? Colors.blue.shade700 : Colors.blue.shade900)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: const OutlineInputBorder(),
                fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                filled: true,
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: isDark ? Colors.blue.shade300 : Colors.blue.shade900,
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