import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Confession {
  String? confessionId;
  String user_uid;
  int confession_no;
  String? confession;
  bool enableAnonymousChat;
  bool enableSpecificIndividuals;
  List views;
  List upvotes;
  List downvotes;
  Map<String, dynamic> reactions;
  Timestamp? datePublished;
  String specificIndividuals;

  Confession({
    this.user_uid = 'not current user',
    this.confessionId,
    this.confession,
    this.enableAnonymousChat = false,
    this.enableSpecificIndividuals = false,
    this.specificIndividuals = '',
    this.views = const [],
    this.upvotes = const [],
    this.downvotes = const [],
    this.reactions = const <String, dynamic>{
      'like': [],
      'love': [],
      'haha': [],
      'wink': [],
      'woah': [],
      'sad': [],
      'angry': []
    },
    this.confession_no = -1,
    this.datePublished,
  });

  Confession toConfessionModel(QueryDocumentSnapshot snapshot) {
    return Confession(
      user_uid: snapshot['user_uid'],
      confessionId: snapshot['confessionId'],
      confession: snapshot['confession'],
      enableAnonymousChat: snapshot['enableAnonymousChat'],
      enableSpecificIndividuals: snapshot['enableSpecificIndividuals'],
      views: snapshot['views'],
      upvotes: snapshot['upvotes'],
      downvotes: snapshot['downvotes'],
      reactions: snapshot['reactions'],
      confession_no: snapshot['confession_no'],
      datePublished: snapshot['datePublished'],
      specificIndividuals: snapshot['specificIndividuals'],
    );
  }
}

class User {
  String uid;
  String avatarURL;

  User({required this.uid, this.avatarURL = 'default'});
}

class Emoji {
  final String path;
  final double scale;

  Emoji({required this.path, required this.scale});
}

class Comment {
  String? confessionId;
  String? commentId;
  String? comment;
  String? user_uid;
  String? avatarURL;
  List upvotes;
  List downvotes;
  Map<String, dynamic> reactions;
  Timestamp? datePublished;

  Comment({
    this.confessionId,
    this.commentId,
    this.comment,
    this.user_uid,
    this.avatarURL,
    this.upvotes = const [],
    this.downvotes = const [],
    this.reactions = const {
      'like': [],
      'love': [],
      'haha': [],
      'wink': [],
      'woah': [],
      'sad': [],
      'angry': [],
    },
    this.datePublished,
  });

  Comment toCommentModel(QueryDocumentSnapshot snapshot) {
    return Comment(
        commentId: snapshot['commentId'],
        confessionId: snapshot['confessionId'],
        comment: snapshot['comment'],
        user_uid: snapshot['user_uid'],
        avatarURL: snapshot['avatarURL'],
        datePublished: snapshot['datePublished'],
        upvotes: snapshot['upvotes'],
        downvotes: snapshot['downvotes'],
        reactions: snapshot['reactions']);
  }
}
