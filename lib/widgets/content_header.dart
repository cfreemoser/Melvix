import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/widgets/vertical_icon_button.dart';

class ContentHeader extends StatelessWidget {
  final Content featuredContent;

  const ContentHeader({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(featuredContent.headerImageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 500,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.transparent,
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
        ),
        Positioned(
          bottom: 110,
          child: SizedBox(
            width: 250,
            child: Text(
              featuredContent.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButton(
                icon: Icons.add,
                title: "List",
                onTap: () {},
              ),
              _PlayButton(),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: "Info",
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => log("played"),
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(15, 5, 20, 5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.play_arrow,
              color: Colors.black,
            ),
            Text(
              "Play",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ));
  }
}
