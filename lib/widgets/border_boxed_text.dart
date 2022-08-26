import 'package:flutter/material.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class BorderBoxedText extends StatelessWidget {
  final double width;
  final double hight;
  final String text;
  final double scaleFactor = 1.45;

  const BorderBoxedText(
      {Key? key, required this.width, required this.hight, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: hight,
      child: Stack(children: [
        Positioned.fill(
          child: Transform.scale(
            scale: scaleFactor,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 70,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Constants.netflix_grey,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Transform.scale(
            scale: scaleFactor,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )),
      ]),
    );
  }
}
