import 'package:flutter/material.dart';

class VoteAnimation extends StatefulWidget {
  Color color;
  double icon_size;
  bool isAnimating;
  VoteAnimation(
      {super.key,
      required this.color,
      this.icon_size = 35.0,
      this.isAnimating = false});

  @override
  State<VoteAnimation> createState() => _VoteAnimationState();
}

class _VoteAnimationState extends State<VoteAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _voteAnimationController;
  Animation<Offset>? _offset;
  Animation<double>? _scale;

  @override
  void initState() {
    super.initState();
    //Size size = MediaQuery.of(context).size;
    _voteAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // _offset = Tween<Offset>(
    //   begin: const Offset(0.0, 0.0),
    //   end: const Offset(),
    // ).animate(_voteAnimationController!);
    _scale =
        Tween<double>(begin: 1.0, end: 2.5).animate(_voteAnimationController!);
  }

  @override
  void dispose() {
    super.dispose();
    _voteAnimationController!.dispose();
  }

  @override
  void didUpdateWidget(covariant VoteAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    await _voteAnimationController!.forward();
    await Future.delayed(const Duration(milliseconds: 20));
    await _voteAnimationController!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale!,
      child: Transform.rotate(
        angle: widget.color == Colors.green
            ? -1.5707963267948966
            : 1.5707963267948966,
        child: Icon(
          Icons.play_arrow,
          color: widget.color,
          size: widget.icon_size,
        ),
      ),
    );
  }
}
