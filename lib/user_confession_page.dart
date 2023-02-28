import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/anonymous_namecard_widget.dart';
import 'package:untitled2/comments_page.dart';
import 'package:untitled2/Custom_IconText_button.dart';
import 'package:untitled2/firestore_methods.dart';
import 'package:untitled2/models.dart';
import 'package:untitled2/single_reaction_widget.dart';
import 'package:untitled2/custom_vertical_divider.dart';
import 'package:untitled2/vote_animationII.dart';
import 'package:untitled2/vote_clipper.dart';
import 'models.dart' as Models;

class UserConfessionPage extends StatefulWidget {
  int rank;
  Confession confession;
  String avatarURL;
  UserConfessionPage(
      {super.key,
      required this.confession,
      required this.avatarURL,
      this.rank = -1});

  @override
  State<UserConfessionPage> createState() => _UserConfessionPageState();
}

class _UserConfessionPageState extends State<UserConfessionPage> {
  String reaction = 'none';
  bool isUpVoteAnimating = false;
  bool isDownVoteAnimating = false;
  bool enableReactions = false;
  bool justInitialized = true;

  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List medal_asset_paths = [
    'assets/images/gold_medal.png',
    'assets/images/silver_medal.png',
    'assets/images/bronze_medal.png'
  ];

  List<double> emojiState = [0, 0, 0, 0, 0, 0, 0];
  double currentHoverposition = 0;
  int currentSelectedEmoji = -1;

  final List<Models.Emoji> emojis = [
    Models.Emoji(path: 'assets/emoticons/9420-thumbs-up.json', scale: 1.2),
    Models.Emoji(
        path: 'assets/emoticons/11057-simple-elegant-like-heart-animation.json',
        scale: 1.0),
    Models.Emoji(path: 'assets/emoticons/2093-laugh.json', scale: 1.0),
    Models.Emoji(
        path: 'assets/emoticons/114067-wink-tongue-out-emoji-animation.json',
        scale: 1.3),
    Models.Emoji(path: 'assets/emoticons/2086-wow.json', scale: 1.0),
    Models.Emoji(path: 'assets/emoticons/34175-sad-face.json', scale: 0.85),
    Models.Emoji(path: 'assets/emoticons/51920-angry.json', scale: 1.2),
  ];

  final List<String> reactions = [
    'like',
    'love',
    'haha',
    'wink',
    'woah',
    'sad',
    'angry'
  ];

  final Map<String, SingleReactionWidget> reactionButtons = {
    'like': SingleReactionWidget(
      label: 'like',
      label_color: Colors.blue,
      horizontal_padding: 15.0,
      emoji_path: 'assets/emoticons/82649-thumbs-up.json',
      lottie: true,
    ),
    'love': SingleReactionWidget(
      label: 'love',
      label_color: Colors.red,
      horizontal_padding: 11.5,
      emoji: '❤️',
      emoji_size: 25.0,
    ),
    'haha': SingleReactionWidget(
      label: 'haha',
      label_color: Colors.amber,
      horizontal_padding: 6.5,
      emoji: '😆',
      emoji_size: 27.0,
    ),
    'wink': SingleReactionWidget(
      label: 'wink',
      label_color: Colors.amber,
      horizontal_padding: 8.0,
      emoji: '😜',
      emoji_size: 27.0,
    ),
    'woah': SingleReactionWidget(
      label: 'woah',
      label_color: Colors.amber,
      horizontal_padding: 4.5,
      emoji: '😯',
      emoji_size: 27.0,
    ),
    'sad': SingleReactionWidget(
      label: 'sad',
      label_color: Colors.amber,
      horizontal_padding: 13.0,
      emoji: '😔',
      emoji_size: 27.0,
    ),
    'angry': SingleReactionWidget(
      label: 'angry',
      label_color: Colors.orange,
      horizontal_padding: 3.5,
      emoji: '😡',
      emoji_size: 27.0,
    ),
  };

  // Future<void> update() async {
  //   DocumentSnapshot snapshot = await _firestore
  //       .collection('confessions')
  //       .doc(widget.confession.confessionId)
  //       .get();
  //   if (snapshot['upvotes'].contains(_auth.currentUser!.uid)) {
  //     setState(() {
  //       userVote = 'upvote';
  //       upvotes = snapshot['upvotes'].length;
  //       downvotes = snapshot['downvotes'].length;
  //     });
  //   } else if (snapshot['downvotes'].contains(_auth.currentUser!.uid)) {
  //     setState(() {
  //       userVote = 'downvote';
  //       upvotes = snapshot['upvotes'].length;
  //       downvotes = snapshot['downvotes'].length;
  //     });
  //   } else {
  //     setState(() {
  //       userVote = 'none';
  //       upvotes = snapshot['upvotes'].length;
  //       downvotes = snapshot['downvotes'].length;
  //     });
  //   }
  // }

  void nextEmoji() {
    currentSelectedEmoji < emojis.length - 1
        ? currentSelectedEmoji++
        : currentSelectedEmoji = emojis.length - 1;
    for (int j = 0; j < emojiState.length; j++) {
      if (currentSelectedEmoji != -1) {
        j == currentSelectedEmoji ? emojiState[j] = 0.5 : emojiState[j] = -0.3;
      } else {
        emojiState[j] = 0;
      }
    }
  }

  void prevEmoji() {
    currentSelectedEmoji > 0
        ? currentSelectedEmoji--
        : currentSelectedEmoji = 0;
    for (int j = 0; j < emojiState.length; j++) {
      if (currentSelectedEmoji != -1) {
        j == currentSelectedEmoji ? emojiState[j] = 0.5 : emojiState[j] = -0.3;
      } else {
        emojiState[j] = 0;
      }
    }
  }

  Future<void> _upvoted(
      DocumentSnapshot<Map<String, dynamic>> confession_snapshot,
      {bool disable = false}) async {
    if (disable) {
      String res = await _firestoreMethods.actionOnConfession(
          'disable_upvote',
          widget.confession.confessionId!,
          _auth.currentUser!.uid,
          confession_snapshot);
    } else {
      await _firestoreMethods.actionOnConfession(
          'disable_downvote',
          widget.confession.confessionId!,
          _auth.currentUser!.uid,
          confession_snapshot);
      String res = await _firestoreMethods.actionOnConfession(
          'enable_upvote',
          widget.confession.confessionId!,
          _auth.currentUser!.uid,
          confession_snapshot);
    }
  }

  Future<void> _downvoted(
      DocumentSnapshot<Map<String, dynamic>> confession_snapshot,
      {bool disable = false}) async {
    if (disable) {
      String res = await _firestoreMethods.actionOnConfession(
          'disable_downvote',
          widget.confession.confessionId!,
          _auth.currentUser!.uid,
          confession_snapshot);
    } else {
      await _firestoreMethods.actionOnConfession(
          'disable_upvote',
          widget.confession.confessionId!,
          _auth.currentUser!.uid,
          confession_snapshot);
      String res = await _firestoreMethods.actionOnConfession(
          'enable_downvote',
          widget.confession.confessionId!,
          _auth.currentUser!.uid,
          confession_snapshot);
    }
  }

  Future<String> _reacted(int reaction_idx,
      DocumentSnapshot<Map<String, dynamic>> confession_snapshot,
      {bool disable = false}) async {
    String res = 'Some error occurred.';
    if (reaction_idx == 0) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_like',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_like',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'like';
    } else if (reaction_idx == 1) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_love',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_love',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'love';
    } else if (reaction_idx == 2) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_haha',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_haha',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'haha';
    } else if (reaction_idx == 3) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_wink',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_wink',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'wink';
    } else if (reaction_idx == 4) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_woah',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_woah',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'woah';
    } else if (reaction_idx == 5) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_sad',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_sad',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'sad';
    } else if (reaction_idx == 6) {
      disable
          ? await _firestoreMethods.actionOnConfession(
              'disable_angry',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot)
          : await _firestoreMethods.actionOnConfession(
              'enable_angry',
              widget.confession.confessionId!,
              _auth.currentUser!.uid,
              confession_snapshot);
      res = 'angry';
    }
    return res;
  }

  int _reactionToIdx(String reaction) {
    int res = -1;
    if (reaction == 'like') {
      res = 0;
    } else if (reaction == 'love') {
      res = 1;
    } else if (reaction == 'haha') {
      res = 2;
    } else if (reaction == 'wink') {
      res = 3;
    } else if (reaction == 'woah') {
      res = 4;
    } else if (reaction == 'sad') {
      res = 5;
    } else if (reaction == 'angry') {
      res = 6;
    }
    return res;
  }

  String _searchReaction(
      DocumentSnapshot<Map<String, dynamic>> snapshot, String user_uid) {
    String res = 'Some error occurred.';
    if (snapshot['reactions']['like'].contains(user_uid)) {
      res = 'like';
    } else if (snapshot['reactions']['love'].contains(user_uid)) {
      res = 'love';
    } else if (snapshot['reactions']['haha'].contains(user_uid)) {
      res = 'haha';
    } else if (snapshot['reactions']['wink'].contains(user_uid)) {
      res = 'wink';
    } else if (snapshot['reactions']['woah'].contains(user_uid)) {
      res = 'woah';
    } else if (snapshot['reactions']['sad'].contains(user_uid)) {
      res = 'sad';
    } else if (snapshot['reactions']['angry'].contains(user_uid)) {
      res = 'angry';
    } else {
      res = 'none';
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('confessions')
            .doc(widget.confession.confessionId)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('Please check your internet connection'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting &&
              justInitialized) {
            justInitialized = false;
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == null) {
              return const Center(
                child: Text('Some error occurred. Please refresh this page.'),
              );
            } else {
              reaction =
                  _searchReaction(snapshot.data!, _auth.currentUser!.uid);
              return Scaffold(
                backgroundColor: Colors.grey,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: const Color.fromARGB(255, 27, 130, 213),
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      size: 30.0,
                      color: Color.fromARGB(255, 237, 237, 237),
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    'Confession #${widget.confession.confession_no}',
                    style: GoogleFonts.caveat(
                      textStyle: const TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 255, 255, 255),
                          letterSpacing: 0.5),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        size: 30.0,
                        color: Color.fromARGB(255, 237, 237, 237),
                      ),
                    )
                  ],
                ),
                body: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 27, 130, 213),
                            Color.fromARGB(255, 240, 240, 240),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            //color: Colors.amber,
                            height: 621.0,
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: 510.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(3.0),
                                    ),
                                    border: Border.all(
                                        width: 2.5, color: Colors.black54),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/paper_background.jpg'),
                                    ),
                                    color: const Color.fromARGB(
                                        255, 237, 237, 237),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 17.0,
                                  ).copyWith(
                                    top: 80.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0)
                                      .copyWith(bottom: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                      ),
                                      RawScrollbar(
                                        thickness: 5.0,
                                        thumbColor:
                                            const Color.fromARGB(71, 0, 0, 0),
                                        child: SizedBox(
                                          height: 420.0,
                                          child: SingleChildScrollView(
                                              //'All is well. Believe it. I know some of you like me are really dissapointed with the amount of shit you need to go through. But trust is important. It will take us anywhere we want to go. Obsession is necessary. Fuck grit! Let\'s do it!'
                                              child: Text(
                                            snapshot.data!['confession'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17.0),
                                          )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 55.0,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          child: Hero(
                                            tag:
                                                widget.confession.confession_no,
                                            child: CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: widget
                                                          .avatarURL ==
                                                      'default'
                                                  ? const AssetImage(
                                                          'assets/images/default_avatar.jpg')
                                                      as ImageProvider
                                                  : NetworkImage(
                                                      widget.avatarURL),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0.0,
                                          child: widget.confession.user_uid ==
                                                  _auth.currentUser!.uid
                                              ? AnonymousNameCard(
                                                  isCurrentUser: true,
                                                )
                                              : AnonymousNameCard(),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Text(
                                        DateFormat.yMMMMd().format(widget
                                            .confession.datePublished!
                                            .toDate()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.rank == -1
                                    ? Container()
                                    : Positioned(
                                        top: 80.0,
                                        right: 20.0,
                                        child: Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  medal_asset_paths[
                                                      widget.rank - 1]),
                                            ),
                                          ),
                                        ),
                                        // child: RankClipper(
                                        //   color1: colors1[widget.rank - 1],
                                        //   color2: colors2[widget.rank - 1],
                                        //   text: widget.rank.toString(),
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 88.0,
                            //color: Colors.amber,
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (!snapshot.data!['upvotes']
                                              .contains(
                                                  _auth.currentUser!.uid)) {
                                            setState(() {
                                              isUpVoteAnimating = true;
                                              isDownVoteAnimating = false;
                                            });
                                            await _upvoted(snapshot.data!);
                                          } else {
                                            setState(() {
                                              isUpVoteAnimating = false;
                                              isDownVoteAnimating = false;
                                            });
                                            await _upvoted(snapshot.data!,
                                                disable: true);
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!['upvotes'].length
                                                  .toString(),
                                              style: GoogleFonts.secularOne(
                                                textStyle: TextStyle(
                                                  fontSize: 20.0,
                                                  color: snapshot
                                                          .data!['upvotes']
                                                          .contains(_auth
                                                              .currentUser!.uid)
                                                      ? Colors.green
                                                      : const Color.fromARGB(
                                                          255, 61, 61, 61),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            isUpVoteAnimating
                                                ? VoteAnimationII(
                                                    color: Colors.green,
                                                    icon_height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                    icon_width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                  )
                                                : VoteClipper(
                                                    color: Colors.green,
                                                    icon_height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                    icon_width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 13.0,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (!snapshot.data!['downvotes']
                                              .contains(
                                                  _auth.currentUser!.uid)) {
                                            setState(() {
                                              isDownVoteAnimating = true;
                                              isUpVoteAnimating = false;
                                            });
                                            await _downvoted(snapshot.data!);
                                          } else {
                                            setState(() {
                                              isDownVoteAnimating = false;
                                              isUpVoteAnimating = false;
                                            });
                                            await _downvoted(snapshot.data!,
                                                disable: true);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              snapshot.data!['downvotes'].length
                                                  .toString(),
                                              style: GoogleFonts.secularOne(
                                                textStyle: TextStyle(
                                                  fontSize: 20.0,
                                                  color: snapshot
                                                          .data!['downvotes']
                                                          .contains(_auth
                                                              .currentUser!.uid)
                                                      ? Colors.red
                                                      : const Color.fromARGB(
                                                          255, 61, 61, 61),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            isDownVoteAnimating
                                                ? VoteAnimationII(
                                                    color: Colors.red,
                                                    icon_height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                    icon_width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                  )
                                                : Transform.translate(
                                                    offset:
                                                        const Offset(0.0, -1.0),
                                                    child: Transform.rotate(
                                                      angle:
                                                          1.5707963267948966 *
                                                              2,
                                                      child: VoteClipper(
                                                        color: Colors.red,
                                                        icon_width:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                        icon_height:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.03,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Flexible(child: Container()),
                                      Text(
                                        (snapshot.data!['reactions']['like']
                                                    .length +
                                                snapshot
                                                    .data!['reactions']['love']
                                                    .length +
                                                snapshot
                                                    .data!['reactions']['haha']
                                                    .length +
                                                snapshot
                                                    .data!['reactions']['wink']
                                                    .length +
                                                snapshot
                                                    .data!['reactions']['woah']
                                                    .length +
                                                snapshot
                                                    .data!['reactions']['sad']
                                                    .length +
                                                snapshot
                                                    .data!['reactions']['angry']
                                                    .length)
                                            .toString(),
                                        style: GoogleFonts.secularOne(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w100,
                                            color: const Color.fromARGB(
                                                255, 61, 61, 61)),
                                      ),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(
                                        'Reactions',
                                        style: GoogleFonts.secularOne(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w100,
                                            color: const Color.fromARGB(
                                                255, 61, 61, 61)),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        snapshot.data!['views'].length
                                            .toString(),
                                        style: GoogleFonts.secularOne(
                                          textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w100,
                                              color: Color.fromARGB(
                                                  255, 61, 61, 61)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(
                                        'views',
                                        style: GoogleFonts.secularOne(
                                          textStyle: const TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w100,
                                              color: Color.fromARGB(
                                                  255, 61, 61, 61)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Divider(
                                    height: 5.0,
                                    thickness: 1.0,
                                    color: Color.fromARGB(255, 61, 61, 61),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    reaction == 'none'
                                        ? CustomIconTextButton(
                                            onPressed: () => setState(() =>
                                                enableReactions =
                                                    !enableReactions),
                                            icon: Icons.favorite_border,
                                            text: 'React')
                                        : TextButton(
                                            onPressed: () async {
                                              int reaction_idx =
                                                  _reactionToIdx(reaction);
                                              setState(
                                                () => reaction = 'none',
                                              );
                                              await _reacted(
                                                  reaction_idx, snapshot.data!,
                                                  disable: true);
                                            },
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    255, 220, 220, 220),
                                              ),
                                            ),
                                            child: reactionButtons[reaction]!),
                                    CustomVerticalDivider(
                                      color:
                                          const Color.fromARGB(255, 61, 61, 61),
                                      height: 35.0,
                                    ),
                                    CustomIconTextButton(
                                        onPressed: () {
                                          setState(
                                            () => enableReactions = false,
                                          );
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  CommentsPage(
                                                confessionId: snapshot
                                                    .data!['confessionId'],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icons.comment_outlined,
                                        text: 'Comment'),
                                    CustomVerticalDivider(
                                      color:
                                          const Color.fromARGB(255, 61, 61, 61),
                                      height: 35.0,
                                    ),
                                    CustomIconTextButton(
                                        onPressed: () {
                                          setState(
                                              () => enableReactions = false);
                                        },
                                        icon: Icons.share,
                                        text: 'Share'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: enableReactions
                          ? MediaQuery.of(context).size.width
                          : 0.0,
                      child: enableReactions
                          ? FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: Color.fromARGB(227, 245, 245, 245),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 60.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (int i = 0; i < emojis.length; i++)
                                      GestureDetector(
                                        onTap: () async {
                                          String res =
                                              await _reacted(i, snapshot.data!);
                                          setState(
                                            () {
                                              emojiState = [
                                                0,
                                                0,
                                                0,
                                                0,
                                                0,
                                                0,
                                                0
                                              ];
                                              enableReactions = false;
                                              reaction = res;
                                            },
                                          );
                                        },
                                        onLongPressDown: (details) {
                                          setState(() {
                                            for (int j = 0;
                                                j < emojiState.length;
                                                j++) {
                                              j == i
                                                  ? emojiState[j] = 0.5
                                                  : emojiState[j] = -0.3;
                                            }
                                            currentSelectedEmoji = i;
                                          });
                                          currentHoverposition =
                                              details.localPosition.dx;
                                        },
                                        onLongPressMoveUpdate: (details) {
                                          double dragDifference =
                                              details.localPosition.dx -
                                                  currentHoverposition;
                                          if (dragDifference.abs() >
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11) {
                                            if (dragDifference > 0) {
                                              setState(() {
                                                nextEmoji();
                                              });
                                            } else {
                                              setState(() {
                                                prevEmoji();
                                              });
                                            }
                                            currentHoverposition =
                                                details.localPosition.dx;
                                          }
                                        },
                                        onLongPressUp: () async {
                                          String res = await _reacted(
                                              currentSelectedEmoji,
                                              snapshot.data!);
                                          setState(
                                            () {
                                              reaction = res;
                                              emojiState = [
                                                0,
                                                0,
                                                0,
                                                0,
                                                0,
                                                0,
                                                0
                                              ];
                                              enableReactions = false;
                                            },
                                          );
                                        },
                                        child: AnimatedScale(
                                          scale: emojiState[i] == 0
                                              ? 1.0
                                              : 1.0 + emojiState[i],
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: Transform.scale(
                                            scale: emojis[i].scale,
                                            child: Lottie.asset(
                                              emojis[i].path,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              );
            }
          }
        });
  }
}
