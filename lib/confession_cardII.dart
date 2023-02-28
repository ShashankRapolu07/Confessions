import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/firestore_methods.dart';
import 'package:untitled2/models.dart' as Models;
import 'package:untitled2/new_card_widget.dart';
import 'package:untitled2/user_confession_page.dart';
import 'package:untitled2/vote_clipper.dart';
import 'package:intl/intl.dart';

class ConfessionCardII extends StatefulWidget {
  bool isNew;
  bool tapped = false;
  int rank;
  Models.Confession confession;
  String avatarURL;
  ConfessionCardII(
      {super.key,
      required this.confession,
      required this.avatarURL,
      this.isNew = false,
      this.rank = -1});

  @override
  State<ConfessionCardII> createState() => _ConfessionCardIIState();
}

class _ConfessionCardIIState extends State<ConfessionCardII> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: AnimatedScale(
        scale: widget.tapped ? 0.90 : 1,
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              widget.tapped = true;
            });
            await Future.delayed(const Duration(milliseconds: 70));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserConfessionPage(
                  confession: widget.confession,
                  avatarURL: widget.avatarURL,
                  rank: widget.rank,
                ),
              ),
            );
            setState(() {
              widget.tapped = false;
            });
            await _firestoreMethods.viewedConfession(
                widget.confession.confessionId!, _auth.currentUser!.uid);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(10.0),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 55.0, right: 10.0, bottom: 3.0),
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(20.0, 20.0),
                      bottomLeft: Radius.elliptical(20.0, 20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black45,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 2.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '#${widget.confession.confession_no.toString()}',
                              style: GoogleFonts.caveat(
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(255, 66, 66, 66),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                              ),
                              child: Text(
                                DateFormat.yMd().format(
                                  widget.confession.datePublished!.toDate(),
                                ),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 12.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Text(
                          widget.confession.confession!,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                      Flexible(child: Container()),
                      Row(
                        children: [
                          // Transform.rotate(
                          //   angle: -1.5707963267948966,
                          //   child: const Icon(
                          //     Icons.play_arrow,
                          //     color: Colors.green,
                          //   ),
                          // ),
                          Text(
                            widget.confession.upvotes.length.toString(),
                            style: GoogleFonts.secularOne(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w100,
                                color: widget.confession.upvotes
                                        .contains(_auth.currentUser!.uid)
                                    ? Colors.green
                                    : const Color.fromARGB(255, 90, 90, 90),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0.0, -1.0),
                            child: Transform.scale(
                              scale: 0.65,
                              child: VoteClipper(
                                color: Colors.green,
                                icon_height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            widget.confession.downvotes.length.toString(),
                            style: GoogleFonts.secularOne(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w100,
                                color: widget.confession.downvotes
                                        .contains(_auth.currentUser!.uid)
                                    ? Colors.red
                                    : const Color.fromARGB(255, 90, 90, 90),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, 0.0),
                            child: Transform.scale(
                              scale: 0.66,
                              child: Transform.rotate(
                                angle: 1.5707963267948966 * 2,
                                child: VoteClipper(
                                  color: Colors.red,
                                  icon_height:
                                      MediaQuery.of(context).size.height *
                                          0.025,
                                ),
                                // child: const Icon(
                                //   Icons.play_arrow,
                                //   color: Colors.red,
                                // ),
                              ),
                            ),
                          ),

                          Flexible(child: Container()),

                          Text(
                            '${widget.confession.reactions['like'].length + widget.confession.reactions['love'].length + widget.confession.reactions['haha'].length + widget.confession.reactions['wink'].length + widget.confession.reactions['woah'].length + widget.confession.reactions['sad'].length + widget.confession.reactions['angry'].length} Reactions',
                            style: GoogleFonts.secularOne(
                              textStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 61, 61, 61),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 9.0,
                          ),
                          Text(
                            '${widget.confession.views.length} views',
                            style: GoogleFonts.secularOne(
                              textStyle: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w100,
                                color: Color.fromARGB(255, 61, 61, 61),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Positioned(
                left: -45.0,
                top: 47.2,
                child: Transform.rotate(
                  angle: -1.5707963267948966,
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.1675,
                    height: MediaQuery.of(context).size.width * 0.118,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // Color.fromARGB(255, 85, 156, 214),
                          // Color.fromARGB(255, 11, 124, 217),
                          Color.fromARGB(255, 87, 163, 226),
                          Colors.lightBlue,
                          Color.fromARGB(255, 11, 136, 237),
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0)
                              .copyWith(left: 9.0),
                          child: Text(
                            'Anonymous',
                            style: GoogleFonts.secularOne(
                              textStyle: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 54, 54, 54),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: Transform.rotate(
                            angle: 1.58,
                            child: CircleAvatar(
                              radius: 16.5,
                              backgroundColor:
                                  const Color.fromARGB(87, 0, 0, 0),
                              child: Hero(
                                tag: widget.confession.confession_no,
                                child: CircleAvatar(
                                  radius: 15.5,
                                  backgroundImage: widget.avatarURL == 'default'
                                      ? const AssetImage(
                                              'assets/images/default_avatar.jpg')
                                          as ImageProvider
                                      : NetworkImage(widget.avatarURL),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              !widget.confession.views.contains(_auth.currentUser!.uid)
                  ? const Positioned(
                      top: -0.1,
                      right: 25.0,
                      child: NewCard(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
