import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.cyan,
        ),
        home: ChatScreen());
  }
}
