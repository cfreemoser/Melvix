import 'dart:math';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class AnimatedReaction extends StatefulWidget {
  final double duration;
  final bool isAnimating;
  final VoidCallback onEnd;

  AnimatedReaction({
    Key? key,
    required this.duration,
    required this.isAnimating,
    required this.onEnd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AnimatedReactionState();
}

class AnimatedReactionState extends State<AnimatedReaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;
  late Animation<double> hightAnimation;

  late Random random;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration.toInt()),
      vsync: this,
    );
    scaleAnimation = Tween<double>(begin: 0.2, end: 0.35).animate(_controller);

    random = Random();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        widget.onEnd();
      }
    });
  }

  Future? doAnimaton() async {
    await _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedReaction oldWidget) {
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.forward();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAnimating
        ? LayoutBuilder(
            builder: (context, constraints) => SizedBox.expand(
              child: Stack(
                children: List.generate(100, (index) => 1)
                    .map((e) => toReactionWidget(
                        constraints.maxWidth, constraints.maxHeight))
                    .toList(),
              ),
            ),
          )
        : Container();
  }

  Widget toReactionWidget(double maxWidth, double maxHeight) {
    var left = random.nextInt(maxWidth.toInt()).toDouble();
    var right = random.nextInt(maxWidth.toInt()).toDouble();
    var bottom = random.nextInt(maxHeight.toInt()).toDouble();
    var negative = random.nextInt(maxHeight.toInt() * 2).toDouble();
    var offsetDirection = random.nextBool();

    var randomOffset = random.nextInt(maxWidth.toInt()).toDouble();

    return PositionedTransition(
      rect: RelativeRectTween(
              begin: RelativeRect.fromLTRB(offsetDirection ? randomOffset : 0,
                  right, offsetDirection ? 0 : randomOffset, -negative),
              end: RelativeRect.fromLTRB(left, 0, right, bottom + 1000))
          .animate(_controller),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(Constants.image_reaction_emoji)),
      ),
    );
  }
}
