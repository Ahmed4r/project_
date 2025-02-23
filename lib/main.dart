import 'dart:convert';

import 'package:flutter/material.dart';


class SpamDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpamDetectionScreen(),
    );
  }
}

class SpamDetectionScreen extends StatefulWidget {
  @override
  _SpamDetectionScreenState createState() => _SpamDetectionScreenState();
}

class _SpamDetectionScreenState extends State<SpamDetectionScreen> {
  final TextEditingController _textController = TextEditingController();
  String _result = "";

  Future<String> _predictSpam(String message) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/predict'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['label'];
    } else {
      throw Exception('Failed to predict spam');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spam Detection App"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter a message to check for spam:",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your message here...",
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: detectSpam,
              child: Text("Detect Spam"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _result == "Spam detected!" ? Colors.red : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}