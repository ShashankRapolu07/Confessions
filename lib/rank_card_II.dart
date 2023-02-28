import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled2/models.dart';
import 'package:untitled2/user_confession_page.dart';

class RankCardII extends StatefulWidget {
  String asset_path;
  Color borderColor;
  Color gradColor1;
  Color gradColor2;
  int rank;
  bool _tapped = false;
  Confession confession;
  String avatarURL;
  RankCardII(
      {super.key,
      required this.asset_path,
      required this.confession,
      required this.avatarURL,
      this.borderColor = Colors.white,
      this.gradColor1 = Colors.white,
      this.gradColor2 = Colors.white,
      this.rank = -1});

  @override
  State<RankCardII> createState() => _RankCardIIState();
}

class _RankCardIIState extends State<RankCardII> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(
          () => widget._tapped = true,
        );
        await Future.delayed(
          const Duration(milliseconds: 190),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserConfessionPage(
              confession: widget.confession,
              avatarURL: widget.avatarURL,
              rank: widget.rank,
            ),
          ),
        );
        setState(
          () => widget._tapped = false,
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.09,
        // decoration:
        //     BoxDecoration(border: Border.all(width: 3.0, color: Colors.black)),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.07,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.asset_path),
                ),
              ),
            ),
            // const SizedBox(
            //   width: 3.0,
            // ),
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: widget._tapped ? 0.85 : 1,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: -22.0,
                    child: Transform.rotate(
                      angle: 4.71,
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.09,
                        height: MediaQuery.of(context).size.width * 0.07,
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 4.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [widget.gradColor1, widget.gradColor2],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.elliptical(20.0, 20.0),
                            topRight: Radius.elliptical(20.0, 20.0),
                          ),
                        ),
                        child: Text(
                          '#3972',
                          style: GoogleFonts.caveat(
                            textStyle: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 238, 238, 238),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.085,
                    decoration: BoxDecoration(
                      border: Border.all(color: widget.borderColor, width: 2.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                        right: 12.0,
                        top: 10.0,
                        bottom: 5.0,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: const Color.fromARGB(220, 255, 255, 255),
                        highlightColor:
                            const Color.fromARGB(255, 193, 193, 193),
                        child: const Text(
                          'My name is anonymous. I would like to reveal about myself. That is the primary purpose of this app. So if you want to be a part of this come and join us. Let\'s disrupt the status quo of people\'s lives. I want to thank you in advance for your time on reading this!',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
