import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled2/auth_methods.dart';
import 'package:untitled2/confession_home_page.dart';
import 'package:untitled2/firestore_methods.dart';
import 'package:untitled2/models.dart' as Models;
import 'package:untitled2/utils.dart';
import 'package:uuid/uuid.dart';

class NewConfessionPage extends StatefulWidget {
  int confessionNum;
  NewConfessionPage({super.key, required this.confessionNum});

  @override
  State<NewConfessionPage> createState() => _NewConfessionPageState();
}

class _NewConfessionPageState extends State<NewConfessionPage> {
  bool _enableSpecificIndividuals = false;
  bool _enableAnonymousChat = false;
  FocusNode _speficiIndividualsFocusNode = FocusNode();
  FocusNode _confessionFocusNode = FocusNode();
  TextEditingController _specificIndividualsController =
      TextEditingController();
  TextEditingController _confessionController = TextEditingController();

  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _authMethods = AuthMethods();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _speficiIndividualsFocusNode.dispose();
    _confessionFocusNode.dispose();
    _confessionController.dispose();
    _specificIndividualsController.dispose();
  }

  void _postNewConfession(
      bool enableAnonymousChat, bool enableSpecificIndividuals) async {
    if (_confessionController.text != '') {
      if (enableSpecificIndividuals &&
          _specificIndividualsController.text == '') {
        showSnackBar(context,
            'Please mention email address(es) of individuals [or] disable the option.');
      } else {
        setState(
          () => _isLoading = true,
        );
        String confession_id = Uuid().v4();
        Timestamp datePublished = Timestamp.now();
        Models.Confession newConfession = Models.Confession(
          confession_no: widget.confessionNum,
          confessionId: confession_id,
          confession: _confessionController.text,
          enableAnonymousChat: enableAnonymousChat,
          enableSpecificIndividuals: enableSpecificIndividuals,
          specificIndividuals: _specificIndividualsController.text,
          datePublished: datePublished,
          reactions: <String, dynamic>{
            'like': [],
            'love': [],
            'haha': [],
            'wink': [],
            'woah': [],
            'sad': [],
            'angry': []
          },
        );
        Models.User user =
            await _authMethods.getUserDetails(_auth.currentUser!.uid);
        String res =
            await _firestoreMethods.postNewConfession(newConfession, user);
        setState(
          () => _isLoading = false,
        );
        Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const ConfessionHomePage(),
        //   ),
        // );
        showSnackBar(context, res);
      }
    } else {
      showSnackBar(context, 'Confession field should not be empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 254, 254, 254),
      // appBar: AppBar(
      //   systemOverlayStyle: SystemUiOverlayStyle.light,
      //   toolbarHeight: 65.0,
      //   elevation: 0.0,
      //   backgroundColor: const Color.fromARGB(255, 28, 128, 210),
      //   leadingWidth: 90.0,
      //   leading: TextButton(
      //     onPressed: () => Navigator.of(context).pop(),
      //     style: ButtonStyle(
      //         overlayColor: MaterialStateProperty.all(
      //             const Color.fromARGB(112, 244, 67, 54)),
      //         padding: MaterialStateProperty.all(
      //             const EdgeInsets.symmetric(vertical: 0.0)
      //                 .copyWith(right: 15.0, left: 0.0))),
      //     child: const Text(
      //       'Cancel',
      //       style: TextStyle(
      //           color: Color.fromARGB(255, 241, 64, 51),
      //           fontWeight: FontWeight.w900,
      //           fontSize: 17.0),
      //     ),
      //   ),
      //   title: Text(
      //     'New Confession',
      //     style: GoogleFonts.secularOne(
      //         textStyle: const TextStyle(
      //             fontSize: 23.0,
      //             fontWeight: FontWeight.w500,
      //             color: Colors.white)),
      //   ),
      //   actions: [
      //     TextButton(
      //         onPressed: () {},
      //         style: ButtonStyle(
      //             padding: MaterialStateProperty.all(
      //                 const EdgeInsets.symmetric(vertical: 0.0)
      //                     .copyWith(right: 9.0, left: 15.0)),
      //             overlayColor: MaterialStateProperty.all(
      //                 const Color.fromARGB(120, 249, 249, 249))),
      //         child: const Text(
      //           'Confess',
      //           style: TextStyle(
      //               color: Color.fromARGB(255, 9, 9, 9),
      //               fontWeight: FontWeight.w900,
      //               fontSize: 17.0),
      //         ))
      //   ],
      // ),
      appBar: AppBar(
        toolbarHeight: 65.0,
        leading: Container(),
        leadingWidth: 0.0,
        titleSpacing: 0.0,
        title: Container(
          width: double.infinity,
          height: 65.0,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 26, 123, 203),
            Colors.lightBlue,
          ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        const Color.fromARGB(112, 244, 67, 54)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 20.0)
                            .copyWith(right: 10.0, left: 8.0))),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Color.fromARGB(255, 241, 64, 51),
                      fontWeight: FontWeight.w900,
                      fontSize: 17.0),
                ),
              ),
              Text(
                'New Confession',
                style: GoogleFonts.secularOne(
                    textStyle: const TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
              TextButton(
                onPressed: () => _postNewConfession(
                    _enableAnonymousChat, _enableSpecificIndividuals),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 20.0)
                            .copyWith(right: 10.0, left: 10.0)),
                    overlayColor: MaterialStateProperty.all(
                        const Color.fromARGB(120, 249, 249, 249))),
                child: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 16, 68, 111),
                  highlightColor: Colors.white,
                  direction: ShimmerDirection.rtl,
                  child: const Text(
                    'Confess',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 17.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Confess to specific individuals?',
                          style: GoogleFonts.secularOne(
                            textStyle: const TextStyle(fontSize: 17.0),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            activeColor:
                                const Color.fromARGB(255, 45, 139, 216),
                            checkColor: Colors.black,
                            splashRadius: 0.0,
                            value: _enableSpecificIndividuals,
                            onChanged: (value) => setState(
                              () => _enableSpecificIndividuals =
                                  !_enableSpecificIndividuals,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextField(
                        controller: _specificIndividualsController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 17.0),
                        cursorColor: Colors.black,
                        cursorHeight: 25.0,
                        maxLines: 3,
                        focusNode: _speficiIndividualsFocusNode,
                        enabled: _enableSpecificIndividuals,
                        //maxLength: 38 * 6,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          hintText: 'Format: email1, email2, ...',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        enableSuggestions: false,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.007,
                    ),
                    Row(
                      children: [
                        Text(
                          'Enable anonymous chat',
                          style: GoogleFonts.secularOne(
                            textStyle: const TextStyle(fontSize: 17.0),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            activeColor:
                                const Color.fromARGB(255, 45, 139, 216),
                            checkColor: Colors.black,
                            splashRadius: 0.0,
                            value: _enableAnonymousChat,
                            onChanged: (value) => setState(
                              () =>
                                  _enableAnonymousChat = !_enableAnonymousChat,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            'Confession number ',
                            style: GoogleFonts.secularOne(
                                textStyle: const TextStyle(fontSize: 17.0)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Text(
                          '#',
                          style: GoogleFonts.secularOne(
                              textStyle: const TextStyle(fontSize: 30.0)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.015,
                        ),
                        Container(
                          height: 40.0,
                          width: 90.0,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 174, 174, 174),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   width:
                              //       MediaQuery.of(context).size.width * 0.035,
                              // ),
                              Text(
                                widget.confessionNum.toString(),
                                style: GoogleFonts.caveat(
                                  textStyle: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        // const Expanded(
                        //   child: TextField(
                        //     cursorColor: Colors.black,
                        //     cursorHeight: 20.0,
                        //     decoration: InputDecoration(
                        //       fillColor: Colors.white,
                        //       filled: true,
                        //       contentPadding:
                        //           EdgeInsets.symmetric(horizontal: 10.0),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(5.0),
                        //         ),
                        //         borderSide: BorderSide(
                        //           color: Colors.black,
                        //           width: 2.0,
                        //         ),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(5.0),
                        //         ),
                        //         borderSide:
                        //             BorderSide(color: Colors.blue, width: 3.0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.018,
                    ),
                    Text(
                      'Write your confession here:',
                      style: GoogleFonts.secularOne(
                          textStyle: const TextStyle(fontSize: 17.0)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.006,
                    ),
                    RawScrollbar(
                      thickness: 5.0,
                      thumbColor: const Color.fromARGB(81, 0, 0, 0),
                      child: TextField(
                        controller: _confessionController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        cursorHeight: 25.0,
                        maxLines: 21,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText:
                              'Please be aware that when confessing, it is important to adhere to ethical practices. For DOs and DONTs, please refer to the question mark icon located above.',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
