import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  // No async initialization needed since we'll handle API calls directly
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HelpCenter());
  }
}

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  // List of suggested questions aligned with WORKFLOW
  final List<String> _suggestedQuestions = [
    "How do I get started?",
    "Tell me about the workflow.",
    "How do I track my progress?",
    "Can I use this offline?",
  ];

  // List to store the chat messages (questions, answers, and suggestions)
  final List<Map<String, dynamic>> _chatMessages = [];

  // Scroll controller to auto-scroll to the bottom of the chat
  final ScrollController _scrollController = ScrollController();

  // Text controller for the input field
  final TextEditingController _textController = TextEditingController();

  // API key and endpoint
  static const String apiKey =
      'AIzaSyBZI4WrtAV7PtdVl0iXtakpEL_t7hQjuVo'; // Replace with your actual API key
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

  @override
  void initState() {
    super.initState();
    // Add initial bot message with suggested questions
    _chatMessages.add({
      'sender': 'bot',
      'message':
          'Hello! I am your HackFusion Assistant. How can I help you navigate the workflow today?',
      'type': 'text',
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Add suggested questions as clickable options
    for (var question in _suggestedQuestions) {
      _chatMessages.add({
        'sender': 'bot',
        'message': question,
        'type': 'suggestion',
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Function to add a question and get the answer from Gemini API
  Future<void> _addMessage(String question, {bool isTyped = false}) async {
    setState(() {
      // Add the user's question
      _chatMessages.add({
        'sender': 'user',
        'message': question,
        'type': 'text',
      });

      // Add a temporary "typing" message
      _chatMessages.add({
        'sender': 'bot',
        'message': 'Typing...',
        'type': 'text',
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    try {
      // Define the system instruction to train the model based on WORKFLOW
      const systemInstruction = '''
    You are the HackFusion Help Center assistant.
Only answer questions related to:
- Hackathons
- Team formation
- Project submission
- Mentorship

Be concise and helpful.
  ''';

      // Prepare the request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": "$systemInstruction\n\nUser question: $question"},
            ],
          },
        ],
      };

      // Make the API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Remove the "Typing..." message
      setState(() {
        _chatMessages.removeWhere((m) => m['message'] == 'Typing...');
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      if (response.statusCode == 200) {
        // Parse the response
        final jsonResponse = jsonDecode(response.body);
        final generatedText =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'];

        // Add the bot's answer
        setState(() {
          _chatMessages.add({
            'sender': 'bot',
            'message':
                generatedText ?? 'Sorry, I couldn’t process your request.',
            'type': 'text',
          });
        });
      } else {
        // This triggers the catch block with the specific status code
        throw Exception('Failed to fetch response: ${response.statusCode}');
      }
    } catch (e) {
      // Handled Error logic for 429 and 403
      setState(() {
        _chatMessages.removeWhere((m) => m['message'] == 'Typing...');

        String userFriendlyError = 'An error occurred. Please try again.';

        if (e.toString().contains('429')) {
          userFriendlyError =
              'Slow down! We hit the rate limit. Please wait a minute before sending another message.';
        } else if (e.toString().contains('403')) {
          userFriendlyError = 'API Key issues. Please check your permissions.';
        }

        _chatMessages.add({
          'sender': 'bot',
          'message': userFriendlyError,
          'type': 'text',
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Clear the text field if the question was typed
    if (isTyped) {
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF413253),
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Chat With Us",
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures tap is detected anywhere
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // Unfocus the keyboard
        },
        child: Column(
          children: [
            // Chat messages area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(screenWidth * 0.04),
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  final message = _chatMessages[index];
                  final isUser = message['sender'] == 'user';
                  final messageType = message['type'];

                  // Handle different message types
                  if (messageType == 'suggestion') {
                    // Suggested question (clickable)
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          _addMessage(message['message']);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.04,
                            ),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Text(
                            message['message'],
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Regular text message (user or bot)
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        constraints: BoxConstraints(
                          maxWidth:
                              screenWidth * 0.7, // Max width for chat bubbles
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF413253)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.04,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message['message'],
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            // Text input field and send button
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Type your question...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: screenWidth * 0.04,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.04,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.04,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.04,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _addMessage(value.trim(), isTyped: true);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF413253)),
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        _addMessage(_textController.text.trim(), isTyped: true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
