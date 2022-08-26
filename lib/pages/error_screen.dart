import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.w600);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
            width: 120,
            margin: const EdgeInsets.only(left: 20),
            child: SvgPicture.asset(
              Constants.netflix_icon_full,
            )),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const Text("Something went wrong", style: textStyle),
                const Text("Daily quota used", style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
