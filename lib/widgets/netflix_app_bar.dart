import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';

class NetflixAppBar extends StatelessWidget {
  final double scrollOffset;

  const NetflixAppBar({Key? key, this.scrollOffset = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      color:
          Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: AdaptiveLayout(
        mobile: _NetflixAppBarMobile(),
        desktop: _NetflixAppBarDesktop(),
      ),
    );
  }
}

class _NetflixAppBarMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          SvgPicture.asset(Constants.netflix_icon_small, height: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppBarButton(
                  text: "TV shows",
                  onTap: () => log("shows"),
                ),
                _AppBarButton(
                  text: "Movies",
                  onTap: () => log("movies"),
                ),
                _AppBarButton(
                  text: "MyList",
                  onTap: () => log("movies"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _NetflixAppBarDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          SvgPicture.asset(Constants.netflix_icon_full, height: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppBarButton(
                  text: "Home",
                  onTap: () => log("shows"),
                ),
                _AppBarButton(
                  text: "Movies",
                  onTap: () => log("movies"),
                ),
                _AppBarButton(
                  text: "MyList",
                  onTap: () => log("movies"),
                ),
                _AppBarButton(
                  text: "MyList",
                  onTap: () => log("movies"),
                ),
                _AppBarButton(
                  text: "MyList",
                  onTap: () => log("movies"),
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => log("search"),
                  icon: Icon(Icons.search),
                  iconSize: 28,
                  color: Colors.white,
                ),
                _AppBarButton(
                  text: "KIDS",
                  onTap: () => log("shows"),
                ),
                _AppBarButton(
                  text: "DVD",
                  onTap: () => log("movies"),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => log("search"),
                  icon: const Icon(Icons.card_giftcard),
                  iconSize: 28,
                  color: Colors.white,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => log("search"),
                  icon: const Icon(Icons.notifications),
                  iconSize: 28,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  const _AppBarButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: "NetflixSans");

    return GestureDetector(
      child: Text(text, style: textStyle),
      onTap: () => onTap,
    );
  }
}
