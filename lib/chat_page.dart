import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'widgets/app_drawer.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
//import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ChatPage extends StatefulWidget {
  final int category;

  const ChatPage({
    super.key,
    required this.category
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _showGreeting = true; // State variable to manage greeting visibility
  var firstName = "Arun"; // Variable to hold the username

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchUserName(); // Fetch the user's name when the widget is initialized
  // }
  // //
  // Future<void> _fetchUserName() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   print(user?.uid);
  //   if (user != null) {
  //     FirebaseFirestore.instance.collection("finix").doc(user.uid).get().then(
  //           (docSnapshot) {
  //         if (docSnapshot.exists) {
  //           firstName = docSnapshot.data()?["first_name"];
  //           print("User's first name: $firstName");
  //         } else {
  //           print("User not found!");
  //         }
  //       },
  //       onError: (e) => print("Error fetching user: $e"),
  //     );
  //   }
  // }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessageToServer(String message) async {
    final url = Uri.parse('https://finix-backend.vercel.app/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': message,
          'category': widget.category
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _messages.add(ChatMessage(
            text: responseData['response'],
            isUser : false,
          ));
        });
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Hi, How can I help you? You can try asking me about a particular Stock, I can analyze the market for you to help you take the decision.\n If you are trying to know details of other companies that are out of my knowledge right now(I will be updated soon) or you are trying to know about something related to finance. Go to my friend Educator. He knows is like a book that will help you learn\n The best way to get better at finance is to learn and deepen your understanding.",
          isUser : false,
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
        isUser : true,
      ));
      _messageController.clear();
      _scrollToBottom();
      _showGreeting = false; // Hide greeting when a message is sent
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
        title: const Text('Finix AI'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (_showGreeting) // Show greeting if _showGreeting is true
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade800.withValues(alpha: 0.7), // Translucent background
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hi $firstName", // Display the fetched username
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\"The stock market is a device to transfer money from the impatient to the patient.\" - Warren Buffett",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      alignment: message.isUser  ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser  ? Colors.blue.shade700 : Colors.grey.shade800,
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
              onTap: () {
                if (_showGreeting) {
                  setState(() {
                    _showGreeting = false; // Hide greeting when the user taps the input area
                  });
                }
              },
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
  final bool isUser ;

  ChatMessage({
    required this.text,
    required this.isUser ,
  });
}