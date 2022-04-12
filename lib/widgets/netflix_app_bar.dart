import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:shimmer/shimmer.dart';

class NetflixAppBar extends StatelessWidget {
  final double scrollOffset;
  final int selectedIndex;
  final Function quickLaughterTap;
  final Function topTenTap;
  final Function friendsTap;
  final Function highlightsTap;
  final Function allTap;

  const NetflixAppBar(
      {Key? key,
      this.scrollOffset = 0.0,
      required this.quickLaughterTap,
      required this.topTenTap,
      required this.friendsTap,
      required this.highlightsTap,
      required this.allTap,
      required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      color:
          Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: AdaptiveLayout(
        mobile: _NetflixAppBarMobile(
          highlightsTap: highlightsTap,
          friendsTap: friendsTap,
          topTenTap: topTenTap,
          quickLaughterTap: quickLaughterTap,
          selectedIndex: selectedIndex,
        ),
        desktop: _NetflixAppBarDesktop(
          highlightsTap: highlightsTap,
          topTenTap: topTenTap,
          quickLaughterTap: quickLaughterTap,
          friendsTap: friendsTap,
          allTap: allTap,
          selectedIndex: selectedIndex,
        ),
      ),
    );
  }
}

class _NetflixAppBarMobile extends StatelessWidget {
  final Function quickLaughterTap;
  final Function topTenTap;
  final Function friendsTap;
  final Function highlightsTap;
  final int selectedIndex;

  const _NetflixAppBarMobile(
      {Key? key,
      required this.quickLaughterTap,
      required this.topTenTap,
      required this.friendsTap,
      required this.highlightsTap,
      required this.selectedIndex})
      : super(key: key);

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
                  selected: selectedIndex == 0,
                  text: "TOP 10",
                  onTap: () => topTenTap(),
                ),
                _AppBarButton(
                  selected: selectedIndex == 1,
                  text: "Friends",
                  onTap: () => friendsTap(),
                ),
                _AppBarButton(
                  selected: selectedIndex == 2,
                  text: "Highlights",
                  onTap: () => highlightsTap(),
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
  final Function quickLaughterTap;
  final Function topTenTap;
  final Function friendsTap;
  final Function highlightsTap;
  final Function allTap;
  final int selectedIndex;

  const _NetflixAppBarDesktop(
      {Key? key,
      required this.quickLaughterTap,
      required this.topTenTap,
      required this.friendsTap,
      required this.highlightsTap,
      required this.allTap,
      required this.selectedIndex})
      : super(key: key);

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
                  selected: selectedIndex == 0,
                  text: "TOP 10",
                  onTap: () => topTenTap(),
                ),
                _AppBarButton(
                  selected: selectedIndex == 1,
                  text: "Friends",
                  onTap: () => friendsTap(),
                ),
                _AppBarButton(
                  selected: selectedIndex == 2,
                  text: "Highlights",
                  onTap: () => highlightsTap(),
                ),
                _AppBarButton(
                  selected: selectedIndex == 4,
                  text: "All",
                  onTap: () => allTap(),
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => quickLaughterTap(),
                  icon: const Icon(Icons.emoji_emotions),
                  iconSize: 28,
                  color:
                      selectedIndex == 5 ? Constants.netflix_red : Colors.white,
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
    required this.selected,
  }) : super(key: key);

  final String text;
  final Function onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        color: selected ? Constants.netflix_red : Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: "NetflixSans");

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Text(text, style: textStyle),
        onTap: () => onTap(),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  final bool highlighted;

  const LoadingCard({Key? key, required this.highlighted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 55, 53, 53),
            highlightColor: const Color.fromARGB(255, 109, 108, 108),
            child: SizedBox(
              height: highlighted ? 400 : 200,
              width: highlighted ? 200 : 130,
              child: Container(
                color: Colors.white,
              ),
            )));
  }
}
