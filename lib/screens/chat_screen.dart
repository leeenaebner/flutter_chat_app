import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, index) => Container(
            padding: EdgeInsets.all(8),
            child: Text("this.works"),
          ),
          itemCount: 5,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Firestore.instance
                .collection("chats/U5WkPX7Zfk4KwDNAP5So/messages")
                .snapshots()
                .listen((data) {
              data.documents.forEach((doc) => print(doc['text']));
            });
          },
          child: Icon(Icons.add),
        ));
  }
}
