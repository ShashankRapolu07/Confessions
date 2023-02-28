import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/firestore_methods.dart';
import 'package:untitled2/user_provider.dart';
import 'package:untitled2/utils.dart';
import 'models.dart' as Models;

class CommentsPage extends StatefulWidget {
  String confessionId;
  CommentsPage({super.key, required this.confessionId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _userCommentController = TextEditingController();
  FocusNode _commentFieldFocus = FocusNode();

  bool isCommentOnLongPress = false;
  bool _isLoading = false;
  bool _justInitialized = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  void dispose() {
    super.dispose();
    _userCommentController.dispose();
    _commentFieldFocus.dispose();
  }

  Future<void> _writeComment(String confession_id, String comment,
      String user_uid, String avatarURL) async {
    if (comment == '') {
      showSnackBar(context, 'Comment field should not be empty.');
    } else {
      String res = await _firestoreMethods.writeComment(
          confession_id, comment, user_uid, avatarURL);
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Models.User currentUser = Provider.of<UserProvider>(context).getUser!;
    return StreamBuilder(
        stream: _firestore
            .collection('confessions')
            .doc(widget.confessionId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _justInitialized) {
            _justInitialized = false;
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('Please check your internet connection'),
            );
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: const Color.fromARGB(238, 236, 236, 236),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Container(
                  height: 57.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.lightBlue,
                      Color.fromARGB(255, 26, 123, 203),
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            _commentFieldFocus.unfocus();
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30.0,
                            color: Color.fromARGB(255, 249, 249, 249),
                          )),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Comments',
                        style: GoogleFonts.secularOne(
                          textStyle: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 249, 249, 249),
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Text('No comments yet'),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return CommentCard(
                                  comment: Models.Comment().toCommentModel(
                                      snapshot.data!.docs[index]));
                            },
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.08,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      bottom: 5.0,
                      top: 5.0,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 31, 173, 239),
                          Color.fromARGB(255, 28, 132, 217),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(235, 172, 172, 172),
                          spreadRadius: 2.0,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.5,
                          backgroundColor: const Color.fromARGB(87, 0, 0, 0),
                          child: currentUser.avatarURL == 'default'
                              ? const CircleAvatar(
                                  radius: 17.0,
                                  backgroundImage: AssetImage(
                                      'assets/images/default_avatar.jpg'),
                                )
                              : CircleAvatar(
                                  radius: 17.0,
                                  backgroundImage:
                                      NetworkImage(currentUser.avatarURL),
                                ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.0585,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 248, 248, 248),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: RawScrollbar(
                              thumbColor: Colors.black38,
                              child: TextField(
                                controller: _userCommentController,
                                focusNode: _commentFieldFocus,
                                maxLines: 2,
                                cursorColor: Colors.black,
                                cursorHeight: 25.0,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 7.0,
                                    right: 5.0,
                                    top: 10.0,
                                  ),
                                  hintText: 'Comment as anonymous...',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  enabled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                      _commentFieldFocus.unfocus();
                                    });
                                    await _writeComment(
                                        widget.confessionId,
                                        _userCommentController.text,
                                        _auth.currentUser!.uid,
                                        currentUser.avatarURL);
                                    setState(
                                      () {
                                        _isLoading = false;
                                        _userCommentController.text = '';
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
