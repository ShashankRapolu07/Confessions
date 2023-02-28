import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/models.dart' as Models;
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> postNewConfession(
      Models.Confession confession, Models.User user) async {
    String res = 'Some error occurred.';
    try {
      await _firestore
          .collection('confessions')
          .doc(confession.confessionId)
          .set({
        'avatarURL': user.avatarURL,
        'datePublished': confession.datePublished,
        'views': confession.views,
        'upvotes': confession.upvotes,
        'downvotes': confession.downvotes,
        'reactions': confession.reactions,
        'confession': confession.confession,
        'enableAnonymousChat': confession.enableAnonymousChat,
        'user_uid': user.uid,
        'confession_no': confession.confession_no,
        'confessionId': confession.confessionId,
        'enableSpecificIndividuals': confession.enableSpecificIndividuals,
        'specificIndividuals': confession.specificIndividuals,
      });
      res = 'confession posted successfully';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> viewedConfession(String confession_id, String user_uid) async {
    String res = 'Some error occurred';
    try {
      await _firestore.collection('confessions').doc(confession_id).update({
        'views': FieldValue.arrayUnion([user_uid])
      });
      res = 'successfully updated view';
    } catch (e) {
      e.toString();
    }
    return res;
  }

  Future<String> actionOnConfession(
      String action_type,
      String confession_id,
      String user_uid,
      DocumentSnapshot<Map<String, dynamic>> confession_snapshot) async {
    String res = 'Some error occurred.';
    if (action_type == 'enable_upvote') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'upvotes': FieldValue.arrayUnion([user_uid])
        });
        res = 'successfully enabled upvote';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_upvote') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'upvotes': FieldValue.arrayRemove([user_uid])
        });
        res = 'successfully disabled upvote';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_downvote') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'downvotes': FieldValue.arrayUnion([user_uid])
        });
        res = 'successfully enabled downvote';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_downvote') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'downvotes': FieldValue.arrayRemove([user_uid])
        });
        res = 'successfully disabled downvote';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_like') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': FieldValue.arrayUnion([user_uid]),
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully enabled like';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_love') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': FieldValue.arrayUnion([user_uid]),
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully enabled love';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_haha') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': FieldValue.arrayUnion([user_uid]),
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully enabled haha';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_wink') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': FieldValue.arrayUnion([user_uid]),
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully enabled wink';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_woah') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': FieldValue.arrayUnion([user_uid]),
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully enabled woah';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_sad') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': FieldValue.arrayUnion([user_uid]),
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully enabled sad';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'enable_angry') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': FieldValue.arrayUnion([user_uid]),
          }
        });
        res = 'successfully enabled angry';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_like') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': FieldValue.arrayRemove([user_uid]),
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully disabled like';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_love') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': FieldValue.arrayRemove([user_uid]),
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully disabled love';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_haha') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': FieldValue.arrayRemove([user_uid]),
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully disabled haha';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_wink') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': FieldValue.arrayRemove([user_uid]),
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully disabled wink';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_woah') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': FieldValue.arrayRemove([user_uid]),
            'sad': confession_snapshot['reactions']['sad'],
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully disabled woah';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_sad') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': FieldValue.arrayRemove([user_uid]),
            'angry': confession_snapshot['reactions']['angry'],
          }
        });
        res = 'successfully disabled sad';
      } catch (e) {
        res = e.toString();
      }
    } else if (action_type == 'disable_angry') {
      try {
        await _firestore.collection('confessions').doc(confession_id).update({
          'reactions': {
            'like': confession_snapshot['reactions']['like'],
            'love': confession_snapshot['reactions']['love'],
            'haha': confession_snapshot['reactions']['haha'],
            'wink': confession_snapshot['reactions']['wink'],
            'woah': confession_snapshot['reactions']['woah'],
            'sad': confession_snapshot['reactions']['sad'],
            'angry': FieldValue.arrayRemove([user_uid]),
          }
        });
        res = 'successfully disabled angry';
      } catch (e) {
        res = e.toString();
      }
    }
    return res;
  }

  Future<String> writeComment(String confession_id, String comment,
      String user_uid, String avatarURL) async {
    String res = 'Some error occurred.';
    String comment_id = Uuid().v4();
    try {
      await _firestore
          .collection('confessions')
          .doc(confession_id)
          .collection('comments')
          .doc(comment_id)
          .set({
        'user_uid': user_uid,
        'commentId': comment_id,
        'confessionId': confession_id,
        'avatarURL': avatarURL,
        'comment': comment,
        'upvotes': [],
        'downvotes': [],
        'reactions': {
          'like': [],
          'love': [],
          'haha': [],
          'wink': [],
          'woah': [],
          'sad': [],
          'angry': [],
        },
        'datePublished': Timestamp.now(),
      });
      res = 'successfully commented';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteComment(String confession_id, String comment_id) async {
    String res = 'Some error occurred.';
    try {
      await _firestore
          .collection('confessions')
          .doc(confession_id)
          .collection('comments')
          .doc(comment_id)
          .delete();
      res = 'successfully deleted comment';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> actionOnComment(
    String action_type,
    String enable,
    String disable,
    Models.Comment comment,
    String user_uid,
  ) async {
    String res = 'Some error occurred.';
    try {
      if (action_type == 'vote') {
        await _firestore
            .collection('confessions')
            .doc(comment.confessionId!)
            .collection('comments')
            .doc(comment.commentId!)
            .update({
          'upvotes': enable == 'upvote'
              ? FieldValue.arrayUnion([user_uid])
              : disable == 'upvote'
                  ? FieldValue.arrayRemove([user_uid])
                  : FieldValue.arrayUnion([]),
          'downvotes': enable == 'downvote'
              ? FieldValue.arrayUnion([user_uid])
              : disable == 'downvote'
                  ? FieldValue.arrayRemove([user_uid])
                  : FieldValue.arrayUnion([]),
        });
        res = 'successfully ${enable}d';
      } else if (action_type == 'reaction') {
        await _firestore
            .collection('confessions')
            .doc(comment.confessionId!)
            .collection('comments')
            .doc(comment.commentId!)
            .update({
          'reactions': {
            'like': enable == 'like'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'like'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['like'],
            'love': enable == 'love'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'love'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['love'],
            'haha': enable == 'haha'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'haha'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['haha'],
            'wink': enable == 'wink'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'wink'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['wink'],
            'woah': enable == 'woah'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'woah'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['woah'],
            'sad': enable == 'sad'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'sad'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['sad'],
            'angry': enable == 'angry'
                ? FieldValue.arrayUnion([user_uid])
                : disable == 'angry'
                    ? FieldValue.arrayRemove([user_uid])
                    : comment.reactions['angry'],
          }
        });
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
