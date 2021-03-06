import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    final fb = FirebaseMessaging();
    fb.requestNotificationPermissions();
    // fb.configure(onMessage: (msg) {
    //   print(msg);
    //   return;
    // }, onLaunch: (msg) {
    //   print(msg);
    //   return;
    // }, onResume: (msg) {
    //   print(msg);
    //   return;
    // }, onBackgroundMessage: (msg) {
    //   print(msg);
    //   return;
    // });

    // final fbm = FirebaseMessaging().instance;
    // fbm.requestPermission();
    // FirebaseMessaging.onMessage.listen((message) {
    //   print(message);
    //   return;
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print(message);
    //   return;
    // });
    // fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Logout")
                    ],
                  ),
                ),
                value: "logout",
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [Expanded(child: Messages()), NewMessage()],
        ),
      ),
    );
  }
}
