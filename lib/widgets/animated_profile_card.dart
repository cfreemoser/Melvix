import 'package:flutter/material.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class AnimatedProfileCard extends StatefulWidget {
  final String name;
  final Image profileImage;
  final double width;
  final double fontSize;

  const AnimatedProfileCard({
    Key? key,
    required this.name,
    required this.profileImage,
    required this.width,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AnimatedProfileCardState();
}

class AnimatedProfileCardState extends State<AnimatedProfileCard> {
  bool isHovered = false;
  double borderWidth = 6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTap: () => onEntered(true),
        onTapDown: (_) => onEntered(true),
        onTapUp: (_) => onEntered(false),
        child: SizedBox(
          child: MouseRegion(
            onEnter: (_) => onEntered(true),
            onExit: (_) => onEntered(false),
            child: Column(
              children: [
                Container(
                  height: widget.width,
                  width: widget.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: widget.profileImage.image, fit: BoxFit.cover),
                      border: isHovered
                          ? Border.all(width: borderWidth, color: Colors.white)
                          : Border.all(
                              width: borderWidth,
                              color: Constants.netflix_background)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.name,
                      style: isHovered
                          ? TextStyle(
                              color: Colors.white, fontSize: widget.fontSize)
                          : TextStyle(
                              color: Colors.grey, fontSize: widget.fontSize)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
