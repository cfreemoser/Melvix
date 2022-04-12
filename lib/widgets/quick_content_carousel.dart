import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/quick_content.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/animated_reaction.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';
import 'package:netflix_gallery/widgets/vertical_icon_button.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

class QuickContentCarousel extends StatefulWidget {
  final List<QuickContent> quickContents;
  final double height;
  final double width;

  const QuickContentCarousel(
      {Key? key,
      required this.quickContents,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  State<QuickContentCarousel> createState() => _QuickContentCarouselState();
}

class _QuickContentCarouselState extends State<QuickContentCarousel> {
  late PreloadPageController _pageController;
  late VideoPlayerController _videoPlayerController;
  final Random _random = Random();
  bool showPicture = false;
  bool showPictureEnabled = true;
  bool isOnPageTurning = false;
  bool animateReaction = false;
  int current = 1;

  @override
  void initState() {
    _pageController =
        PreloadPageController(viewportFraction: 1, initialPage: 1);
    _pageController.addListener(scrollListener);
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
  void dispose() {
    _videoPlayerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (isOnPageTurning &&
        _pageController.page == _pageController.page!.roundToDouble()) {
      setState(() {
        current = _pageController.page!.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning && current.toDouble() != _pageController.page) {
      if ((current.toDouble() - _pageController.page!).abs() > 0.1) {
        setState(() {
          current = _pageController.page!.toInt();
          isOnPageTurning = true;
        });
      }
    } else {
      setState(() {
        current = _pageController.page!.toInt();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      children: [
        PreloadPageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          preloadPagesCount: 3,
          itemBuilder: buildContent,
        ),
        Positioned.fill(
            child: AnimatedReaction(
          duration: 5000,
          isAnimating: animateReaction,
          onEnd: () => setState(() {
            animateReaction = !animateReaction;
          }),
        )),
        Positioned(
            right: 10,
            bottom: 20,
            child: Column(
              children: [
                VerticalIconButton(
                  icon: Icons.face,
                  size: 30,
                  title: 'LOL',
                  onTap: () => setState(() {
                    dev.log("start animation");
                    animateReaction = true;
                  }),
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
                showPictureEnabled
                    ? VerticalIconButton(
                        icon: Icons.picture_in_picture,
                        size: 30,
                        title: 'Fullscreen',
                        enabled: showPictureEnabled,
                        onTap: () => setState(() {
                          showPicture = true;
                        }),
                      )
                    : Container(),
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

    return AdaptiveLayout(
        mobile: stack,
        desktop: Stack(
          children: [
            Positioned.fill(
                child: buildContent(context, current, videoMuted: true)),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            Center(
                child: SizedBox(
                    height: 800,
                    width: 390,
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: stack)))
          ],
        ));
  }

  Widget buildContent(BuildContext context, int itemIndex,
      {bool videoMuted = false}) {
    var currentCurrent = itemIndex % widget.quickContents.length;
    var content = widget.quickContents[currentCurrent];
    return SizedBox(
        key: ValueKey(itemIndex),
        width: widget.width,
        height: widget.height,
        child: content.type == QuickContentType.video
            ? _videoCard(
                isMusted: videoMuted,
                content: content,
                hight: widget.height,
                width: widget.width,
                pageIndex: itemIndex,
                currentPageIndex: current,
              )
            : Image.network(
                content.contentUrl,
                fit: BoxFit.cover,
              ));
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
  final double hight;
  final double width;
  final int pageIndex;
  final int currentPageIndex;
  final bool isMusted;

  const _videoCard(
      {Key? key,
      required this.content,
      required this.hight,
      required this.width,
      required this.pageIndex,
      required this.currentPageIndex,
      required this.isMusted})
      : super(key: key);

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
    if (widget.pageIndex == widget.currentPageIndex &&
        _videoPlayerController.value.isInitialized) {
      _videoPlayerController.setVolume(widget.isMusted ? 0 : 0.3);
    } else {
      _videoPlayerController.setVolume(0);
    }

    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoPlayerController.value.size.width,
              height: _videoPlayerController.value.size.height,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
        ),
      ],
    );
  }
}
