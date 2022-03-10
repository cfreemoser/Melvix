import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/navigation/video_args.dart';
import 'package:netflix_gallery/widgets/player.dart';

class Video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as VideoArgs;
    final args = Content();

    return Scaffold(
      body: Player(content: args),
    );
  }
}
