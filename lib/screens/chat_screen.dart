import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/chat";
  final chatRef =
      Firestore.instance.collection("chats/U5WkPX7Zfk4KwDNAP5So/messages");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          actions: [
            DropdownButton(
              icon: Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
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
        body: StreamBuilder<QuerySnapshot>(
            stream: chatRef.snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.hasError) {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          content: Text("No data in chat"),
                        ));
              }
              final docs = snapshot.data!.documents;
              return ListView.builder(
                itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.all(8),
                  child: Text(docs[index]['text']),
                ),
                itemCount: docs.length,
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            chatRef.add({'text': 'Hi there'});
          },
          child: Icon(Icons.add),
        ));
  }
}
