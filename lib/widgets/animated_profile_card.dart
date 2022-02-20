import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return GestureDetector(
      onTap: () => onEntered(true),
      child: SizedBox(
        child: MouseRegion(
          onEnter: (_) => onEntered(true),
          onExit: (_) => onEntered(false),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: isHovered
                          ? Border.all(width: borderWidth, color: Colors.white)
                          : Border.all(
                              width: borderWidth,
                              color: Constants.netflix_background)),
                  child: Image(
                    image: widget.profileImage.image,
                    fit: BoxFit.fitWidth,
                  )),
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
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
