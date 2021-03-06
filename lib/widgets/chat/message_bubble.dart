import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final bool isMe;
  final String username;
  final String imageUrl;
  final Key key;

  MessageBubble(this.msg, this.username, this.imageUrl, this.isMe,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    isMe ? Colors.red.shade200 : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(3) : Radius.circular(12),
                  bottomRight: !isMe ? Radius.circular(12) : Radius.circular(3),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black54 : Colors.white,
                    ),
                    textAlign: isMe ? TextAlign.start : TextAlign.end,
                  ),
                  Text(
                    msg,
                    style: TextStyle(
                      color: isMe ? Colors.black87 : Colors.white,
                    ),
                    textAlign: isMe ? TextAlign.start : TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -5,
          left: isMe ? 120 : null,
          right: isMe ? null : 120,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
