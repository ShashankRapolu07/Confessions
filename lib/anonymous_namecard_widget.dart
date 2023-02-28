import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnonymousNameCard extends StatelessWidget {
  bool isCurrentUser;
  AnonymousNameCard({super.key, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Color.fromARGB(238, 255, 255, 255),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
      child: isCurrentUser
          ? Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: const Color.fromARGB(255, 235, 235, 235),
              child: const Text(
                'Personal',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17.0,
                ),
              ),
            )
          : const Text(
              'Anonymous',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15.0,
              ),
            ),
    );
  }
}
