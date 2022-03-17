import 'dart:developer';

import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  bool isPlaying;
  final Function onTap;

  PlayButton({Key? key, this.isPlaying = true, required this.onTap})
      : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => buttonClicked(),
      icon: AnimatedIcon(
        icon: AnimatedIcons.pause_play,
        progress: controller,
        color: Colors.white,
      ),
      iconSize: 60,
      color: Colors.white,
    );
  }

  buttonClicked() {
    widget.isPlaying ? controller.forward() : controller.reverse();
    widget.onTap();
  }
}
