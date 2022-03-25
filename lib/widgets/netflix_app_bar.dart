import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:shimmer/shimmer.dart';

class NetflixAppBar extends StatelessWidget {
  final double scrollOffset;
  final Function myListTap;
  final Function topTenTap;
  final Function friendsTap;
  final Function highlightsTap;
  final Function allTap;

  const NetflixAppBar(
      {Key? key,
      this.scrollOffset = 0.0,
      required this.myListTap,
      required this.topTenTap,
      required this.friendsTap,
      required this.highlightsTap,
      required this.allTap})
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
          myListTap: myListTap,
        ),
        desktop: _NetflixAppBarDesktop(
          highlightsTap: highlightsTap,
          topTenTap: topTenTap,
          myListTap: myListTap,
          friendsTap: friendsTap,
          allTap: allTap,
        ),
      ),
    );
  }
}

class _NetflixAppBarMobile extends StatelessWidget {
  final Function myListTap;
  final Function topTenTap;
  final Function friendsTap;
  final Function highlightsTap;

  const _NetflixAppBarMobile(
      {Key? key,
      required this.myListTap,
      required this.topTenTap,
      required this.friendsTap,
      required this.highlightsTap})
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
                  text: "TOP 10",
                  onTap: () => topTenTap(),
                ),
                _AppBarButton(
                  text: "Friends",
                  onTap: () => friendsTap(),
                ),
                _AppBarButton(
                  text: "MyList",
                  onTap: () => myListTap(),
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
  final Function myListTap;
  final Function topTenTap;
  final Function friendsTap;
  final Function highlightsTap;
  final Function allTap;

  const _NetflixAppBarDesktop(
      {Key? key,
      required this.myListTap,
      required this.topTenTap,
      required this.friendsTap,
      required this.highlightsTap,
      required this.allTap})
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
                  text: "TOP 10",
                  onTap: () => topTenTap(),
                ),
                _AppBarButton(
                  text: "Friends",
                  onTap: () => friendsTap(),
                ),
                _AppBarButton(
                  text: "MyList",
                  onTap: () => myListTap(),
                ),
                _AppBarButton(
                  text: "Highlights",
                  onTap: () => highlightsTap(),
                ),
                _AppBarButton(
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
      onTap: () => onTap(),
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
