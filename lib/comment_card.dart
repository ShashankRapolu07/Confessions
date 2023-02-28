import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/comment_clipper.dart';
import 'package:untitled2/firestore_methods.dart';
import 'package:untitled2/models.dart';

class CommentCard extends StatefulWidget {
  Comment comment;
  CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 10.0,
      ),
      child: Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 6.0,
                top: 12.0,
                bottom: 20.0,
              ),
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.black,
                child: widget.comment.avatarURL == 'default'
                    ? const CircleAvatar(
                        radius: 13.0,
                        backgroundImage:
                            AssetImage('assets/images/default_avatar.jpg'),
                      )
                    : CircleAvatar(
                        radius: 13.0,
                        backgroundImage:
                            NetworkImage(widget.comment.avatarURL!),
                      ),
              ),
            ),
            CommentClipper(
              comment: widget.comment,
            ),
          ],
        ),
      ),
    );
  }
}
