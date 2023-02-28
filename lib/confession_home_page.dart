import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/auth_methods.dart';
import 'package:untitled2/confession_cardII.dart';
import 'package:untitled2/login_page.dart';
import 'package:untitled2/new_confession_page.dart';
import 'package:untitled2/rank_card_II.dart';
import 'package:untitled2/rankings_page.dart';
import 'package:untitled2/user_provider.dart';
import 'models.dart' as Models;

class ConfessionHomePage extends StatefulWidget {
  const ConfessionHomePage({super.key});

  @override
  State<ConfessionHomePage> createState() => _ConfessionHomePageState();
}

class _ConfessionHomePageState extends State<ConfessionHomePage> {
  final AuthMethods _authMethods = AuthMethods();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ScrollController _scrollController = ScrollController();
  bool closeRankContainer = false;
  bool _throughInkWell = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        if (!_throughInkWell) {
          closeRankContainer = _scrollController.offset > 90;
        }
      });
    });
    addData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final Models.User currentUser = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 254, 254, 254),
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Container(
          height: 57.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.lightBlue, Color.fromARGB(255, 26, 123, 203)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30.0,
                    color: Color.fromARGB(255, 249, 249, 249),
                  )),
              Text(
                'Confessions',
                style: GoogleFonts.secularOne(
                  textStyle: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 249, 249, 249),
                      letterSpacing: 0.5),
                ),
              ),
              Flexible(child: Container()),
              IconButton(
                onPressed: () async {
                  String res = await _authMethods.logOutUser();
                  if (res == 'successfully logged out.') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                  print(res);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30.0,
                  color: Color.fromARGB(255, 249, 249, 249),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: _firestore
              .collection('confessions')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  confession_snapshot) {
            if (confession_snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (confession_snapshot.connectionState ==
                ConnectionState.active) {
              return Stack(alignment: Alignment.bottomRight, children: [
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue,
                              Color.fromARGB(255, 26, 124, 205)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 4.0,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0)
                          .copyWith(top: 5.0, bottom: 3.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() {
                              closeRankContainer = !closeRankContainer;
                              closeRankContainer
                                  ? _throughInkWell = true
                                  : _throughInkWell = false;
                            }),
                            child: Text(
                              'Top 3 confessions',
                              style: GoogleFonts.secularOne(
                                  textStyle: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ),
                          ),
                          Flexible(child: Container()),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const RankingsPage(),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Rankings',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 249, 249, 249),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Color.fromARGB(255, 249, 249, 249),
                                  size: 17.0,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // AnimatedOpacity(
                    //   duration: const Duration(milliseconds: 400),
                    //   opacity: closeRankContainer ? 0 : 1,
                    //   child: AnimatedContainer(
                    //     duration: const Duration(milliseconds: 400),
                    //     decoration: const BoxDecoration(
                    //       gradient: LinearGradient(colors: [
                    //         Colors.lightBlue,
                    //         Color.fromARGB(255, 2, 98, 177),
                    //       ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    //       borderRadius: BorderRadius.only(
                    //         bottomLeft: Radius.circular(30.0),
                    //         bottomRight: Radius.circular(30.0),
                    //       ),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             offset: Offset(0.0, 5.0),
                    //             blurRadius: 2.0,
                    //             spreadRadius: 0.1,
                    //             color: Colors.grey)
                    //       ],
                    //     ),
                    //     width: double.infinity,
                    //     height: closeRankContainer
                    //         ? 0
                    //         : MediaQuery.of(context).size.height * 0.37,
                    //     child: FittedBox(
                    //       child: Column(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 0.0, vertical: 5.0),
                    //             child: RankCardII(
                    //               asset_path: 'assets/gold_medal.png',
                    //               borderColor: const Color.fromARGB(215, 222, 173, 24),
                    //               gradColor1: const Color.fromARGB(255, 255, 203, 49),
                    //               gradColor2: const Color.fromARGB(255, 143, 109, 9),
                    //               rank: 1,
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 0.0, vertical: 13.0),
                    //             child: RankCardII(
                    //               asset_path: 'assets/silver_medal.png',
                    //               borderColor: const Color.fromARGB(234, 158, 158, 158),
                    //               gradColor1: const Color.fromARGB(255, 204, 204, 204),
                    //               gradColor2: const Color.fromARGB(255, 99, 99, 99),
                    //               rank: 2,
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 0.0, vertical: 10.0),
                    //             child: RankCardII(
                    //               asset_path: 'assets/bronze_medal.png',
                    //               borderColor: const Color.fromARGB(222, 181, 123, 41),
                    //               gradColor1: const Color.fromARGB(255, 253, 167, 46),
                    //               gradColor2: const Color.fromARGB(255, 126, 83, 22),
                    //               rank: 3,
                    //             ),
                    //           )
                    //           // Padding(
                    //           //   padding: const EdgeInsets.symmetric(
                    //           //       horizontal: 10.0, vertical: 10.0),
                    //           //   child: RankCard(
                    //           //       rank: 1,
                    //           //       backgroundColor_start: Colors.amber,
                    //           //       backgroundColor_end:
                    //           //           const Color.fromARGB(197, 233, 176, 5),
                    //           //       textColor: const Color.fromARGB(220, 0, 0, 0),
                    //           //       highlightColor:
                    //           //           const Color.fromARGB(255, 255, 255, 255)),
                    //           // ),
                    //           // Padding(
                    //           //   padding: const EdgeInsets.symmetric(
                    //           //       horizontal: 10.0, vertical: 10.0),
                    //           //   child: RankCardII(
                    //           //       textColor: Color.fromARGB(255, 189, 143, 6),
                    //           //       highlightColor: Colors.amber),
                    //           // ),
                    //           // Padding(
                    //           //   padding: const EdgeInsets.symmetric(
                    //           //       horizontal: 10.0, vertical: 10.0),
                    //           //   child: RankCardII(
                    //           //       textColor: Color.fromARGB(255, 206, 206, 206),
                    //           //       highlightColor: Colors.grey),
                    //           // ),
                    //           // Padding(
                    //           //   padding: const EdgeInsets.symmetric(
                    //           //       horizontal: 10.0, vertical: 10.0),
                    //           //   child: RankCardII(
                    //           //       textColor: Color.fromARGB(255, 64, 40, 32),
                    //           //       highlightColor: Color.fromARGB(255, 122, 83, 70)),
                    //           // ),
                    //           // Padding(
                    //           //     padding: const EdgeInsets.symmetric(
                    //           //         horizontal: 10.0, vertical: 10.0),
                    //           //     child: RankCard(
                    //           //       rank: 2,
                    //           //       backgroundColor_start:
                    //           //           const Color.fromRGBO(192, 192, 192, 1.0),
                    //           //       backgroundColor_end:
                    //           //           const Color.fromARGB(226, 137, 137, 137),
                    //           //       textColor: const Color.fromARGB(220, 0, 0, 0),
                    //           //       highlightColor:
                    //           //           const Color.fromARGB(255, 255, 255, 255),
                    //           //     )),
                    //           // Padding(
                    //           //   padding: const EdgeInsets.symmetric(
                    //           //       horizontal: 10.0, vertical: 10.0),
                    //           //   child: RankCard(
                    //           //       rank: 3,
                    //           //       backgroundColor_start:
                    //           //           const Color.fromRGBO(205, 127, 50, 1.0),
                    //           //       backgroundColor_end:
                    //           //           const Color.fromARGB(255, 150, 82, 59),
                    //           //       textColor: const Color.fromARGB(220, 0, 0, 0),
                    //           //       highlightColor:
                    //           //           const Color.fromARGB(255, 255, 255, 255)),
                    //           // )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // closeRankContainer
                    //     ? const SizedBox(
                    //         height: 0.0,
                    //       )
                    //     : const SizedBox(
                    //         height: 10.0,
                    //       ),
                    Expanded(
                      child: confession_snapshot.data!.docs.isNotEmpty
                          ? ListView.builder(
                              itemCount: confession_snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ConfessionCardII(
                                  confession: Models.Confession()
                                      .toConfessionModel(confession_snapshot
                                          .data!.docs[index]),
                                  avatarURL: confession_snapshot
                                      .data!.docs[index]['avatarURL'],
                                );
                              })
                          : const Center(
                              child: Text('No confessions to show here'),
                            ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 17.0,
                  ),
                  child: FloatingActionButton(
                    onPressed: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => NewConfessionPage(
                            confessionNum:
                                confession_snapshot.data!.docs.length + 1),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 32.0,
                    ),
                  ),
                ),
              ]);
            } else {
              return const Center(
                child: Text('Check your internet connection'),
              );
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.of(context).push(
      //     CupertinoPageRoute(
      //       fullscreenDialog: true,
      //       builder: (context) => const LoginPage(),
      //     ),
      //   ),
      //   child: const Icon(
      //     Icons.add,
      //     size: 32.0,
      //   ),
      // ),
    );
  }
}
