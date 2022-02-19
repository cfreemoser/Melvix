import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class AnimatedProfileCard extends StatefulWidget {
  final String name;
  final Image profileImage;

  AnimatedProfileCard({
    required this.name,
    required this.profileImage,
  });

  @override
  State<StatefulWidget> createState() => AnimatedProfileCardState();
}

class AnimatedProfileCardState extends State<AnimatedProfileCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: Column(
        children: [
          SizedBox(
            height: 206,
            width: 206,
            child: Container(
                decoration: BoxDecoration(
                    border: isHovered
                        ? Border.all(width: 6, color: Colors.white)
                        : Border.all(
                            width: 6, color: Constants.netflix_background)),
                child: widget.profileImage),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.name,
                style: isHovered
                    ? const TextStyle(color: Colors.white, fontSize: 20)
                    : const TextStyle(color: Colors.grey, fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
