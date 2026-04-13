import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header thay AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Logo bên trái
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Image.asset(
                      "assets/images/chatbot.png",
                      width: 40,
                      height: 40,
                    ),
                  ),

                  // Phần giữa
                  Expanded(
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "Rice",
                              style: TextStyle(color: Colors.green),
                            ),
                            TextSpan(
                              text: "Care",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: " AI",
                              style: TextStyle(color: Color(0xFF4CAF50)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Nút more bên phải
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.more_horiz, size: 20),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  chatBubble(
                    isMe: false,
                    text:
                        "Hello 👋\nI'm RiceCare AI\nAsk me anything about rice diseases, symptoms and treatment",
                  ),

                  chatBubble(isMe: true, text: "How to treat rice blast?"),

                  chatBubble(
                    isMe: false,
                    text:
                        "Rice Blast is a fungal disease caused by Magnaporthe oryzae.\n\nTreatment:\n• Reduce plant density\n• Use fungicide\n• Improve drainage",
                  ),

                  chatBubble(isMe: true, text: "Thank you! ❤️"),

                  SizedBox(height: 16),

                  Text(
                    "Quick Suggestions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      suggestionChip("Rice Blast Treatment", Color(0xFFEDF8EC)),
                      suggestionChip("Brown Spot", Color(0xFFF8EFEC)),
                      suggestionChip("Prevent Disease", Color(0xFFECF6F8)),
                      suggestionChip("Yellow Leaves", Color(0xFFFEF9EF)),
                    ],
                  ),
                ],
              ),
            ),

            inputBar(),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required bool isMe, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Image.asset("assets/images/chatbot.png", width: 40, height: 40),
            SizedBox(width: 8),
          ],

          Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              color: isMe ? Colors.green : Color(0xFFE6EFE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget suggestionChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }

  Widget inputBar() {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 40,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Ask me something...",
                border: InputBorder.none,
              ),
            ),
          ),

          Icon(Icons.mic_none_outlined),
          SizedBox(width: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Transform.rotate(
              angle: -0.8,
              child: Icon(Icons.send, color: Colors.green, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
