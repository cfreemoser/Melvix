import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/quick_content.dart';
import 'package:netflix_gallery/widgets/vertical_icon_button.dart';

class QuickContentCarousel extends StatefulWidget {
  final List<QuickContent> quickContents;

  const QuickContentCarousel({Key? key, required this.quickContents})
      : super(key: key);

  @override
  State<QuickContentCarousel> createState() => _QuickContentCarouselState();
}

class _QuickContentCarouselState extends State<QuickContentCarousel> {
  late PageController _pageController;
  final Random _random = Random();
  bool showPicture = false;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.95, initialPage: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemBuilder: (BuildContext context, int itemIndex) {
            var currentCurrent = itemIndex % widget.quickContents.length;
            var content = widget.quickContents[currentCurrent];
            //TODO use interactiveViewer to automatically scroll
            return InteractiveViewer(
              child: FittedBox(
                  fit: BoxFit.cover, child: Image.network(content.contentUrl)),
            );
          },
        ),
        Positioned(
            right: 10,
            bottom: 20,
            child: Column(
              children: [
                VerticalIconButton(
                  icon: Icons.face,
                  size: 30,
                  title: 'LOL',
                  onTap: () => dev.log("s"),
                ),
                const SizedBox(height: 20),
                VerticalIconButton(
                  icon: Icons.rotate_left,
                  size: 30,
                  title: 'Random',
                  onTap: () => setState(() {
                    _pageController.animateToPage(
                        max(_random.nextInt(widget.quickContents.length), 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  }),
                ),
                const SizedBox(height: 20),
                VerticalIconButton(
                  icon: Icons.picture_in_picture,
                  size: 30,
                  title: 'Fullscreen',
                  onTap: () => setState(() {
                    showPicture = true;
                  }),
                ),
              ],
            )),
        Positioned.fill(
            child: showPicture
                ? _overlay(
                    onTap: () => setState(() {
                          showPicture = false;
                        }),
                    imageURL: widget
                        .quickContents[_pageController.page!.toInt() %
                            widget.quickContents.length]
                        .contentUrl)
                : Container()),
      ],
    );
  }
}

class _overlay extends StatelessWidget {
  final String imageURL;
  final Function onTap;

  const _overlay({Key? key, required this.imageURL, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: Image.network(imageURL)),
    );
  }
}
