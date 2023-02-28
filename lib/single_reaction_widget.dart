import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SingleReactionWidget extends StatefulWidget {
  bool lottie;
  bool showLabel;
  String emoji;
  String emoji_path;
  String label;
  Color label_color;
  double horizontal_padding;
  double emoji_size;
  double lottie_scale;
  SingleReactionWidget({
    super.key,
    this.showLabel = true,
    this.emoji = '',
    this.emoji_path = '',
    this.lottie = false,
    required this.label,
    this.label_color = Colors.black,
    required this.horizontal_padding,
    this.emoji_size = 17.0,
    this.lottie_scale = 1.0,
  });

  @override
  State<SingleReactionWidget> createState() => _SingleReactionWidgetState();
}

class _SingleReactionWidgetState extends State<SingleReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontal_padding),
      child: Row(
        children: [
          widget.lottie
              ? Transform.scale(
                  scale: widget.lottie_scale,
                  child: Lottie.asset(
                    widget.emoji_path,
                    animate: false,
                    height: 32.0,
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  widget.emoji,
                  style: TextStyle(fontSize: widget.emoji_size),
                ),
          widget.showLabel
              ? const SizedBox(
                  width: 5.0,
                )
              : Container(),
          widget.showLabel
              ? Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w400,
                    color: widget.label_color,
                  ),
                )
              : Container(),
        ],
      ),
    );
    ;
  }
}
