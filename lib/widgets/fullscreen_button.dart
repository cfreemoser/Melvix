import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';

class FullscreenButton extends StatefulWidget {
  const FullscreenButton({Key? key}) : super(key: key);

  @override
  State<FullscreenButton> createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<FullscreenButton> {
  bool isFullscreen = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => {
        setState(() {
          if (isFullscreen) {
            document.exitFullscreen();
          } else {
            document.documentElement?.requestFullscreen();
          }
          isFullscreen = !isFullscreen;
        })
      },
      icon: Icon(isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
      iconSize: 60,
      color: Colors.white,
    );
  }
}
