import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/quick_content.dart';
import 'package:netflix_gallery/widgets/vertical_icon_button.dart';
import 'package:video_player/video_player.dart';

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
  bool showPictureEnabled = true;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.95, initialPage: 1);
    _pageController.addListener(() {
      setState(() {
        showPictureEnabled = widget
                .quickContents[
                    _pageController.page!.toInt() % widget.quickContents.length]
                .type ==
            QuickContentType.photo;
      });
    });

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
            return InteractiveViewer(
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: content.type == QuickContentType.video
                      ? _videoCard(content: content)
                      : Image.network(content.contentUrl)),
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
                  enabled: showPictureEnabled,
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

class _videoCard extends StatefulWidget {
  final QuickContent content;

  const _videoCard({Key? key, required this.content}) : super(key: key);

  @override
  State<_videoCard> createState() => _videoCardState();
}

class _videoCardState extends State<_videoCard> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      widget.content.contentUrl,
    )
      ..initialize().then((_) {
        setState(() {
          setState(() {});
        });
      })
      ..play()
      ..setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50, width: 50, child: VideoPlayer(_videoPlayerController));
  }
}
