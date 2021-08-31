import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMsg = '';
  final _msgController = TextEditingController();

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();

    FocusScope.of(context).unfocus();
    await Firestore.instance.collection("chat").add({
      'text': _enteredMsg,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'imageUrl': userData['imageUrl'],
      'username': userData['username'],
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "Send message"),
              controller: _msgController,
              onChanged: (val) {
                setState(() {
                  _enteredMsg = val;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMsg.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
