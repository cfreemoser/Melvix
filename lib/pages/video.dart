import 'package:flutter/material.dart';
import 'package:netflix_gallery/navigation/video_args.dart';
import 'package:netflix_gallery/widgets/player.dart';

class Video extends StatelessWidget {
  const Video({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as VideoArgs;
    return Scaffold(
      body: Player(content: args.content),
    );
  }
}
