import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatRef = FirebaseFirestore.instance.collection("chat");
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: chatRef.orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.hasError) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              content: Text("No data in chat"),
            ),
          );
        }
        final docs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => Container(
            padding: EdgeInsets.all(8),
            child: MessageBubble(
              docs[index]['text'],
              docs[index]['username'],
              docs[index]['imageUrl'],
              docs[index]['userId'] == user.uid,
              key: ValueKey(
                docs[index].id,
              ),
            ),
          ),
          itemCount: docs.length,
        );
      },
    );
  }
}
