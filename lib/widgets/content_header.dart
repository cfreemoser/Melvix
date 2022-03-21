import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/topcontent_list.dart';
import 'package:netflix_gallery/widgets/vertical_icon_button.dart';
import 'package:video_player/video_player.dart';

class ContentHeader extends StatelessWidget {
  final List<Content> topContent;
  final double hight;
  final double width;
  final Function(Content selectedContent) onContentSelected;

  const ContentHeader(
      {Key? key,
      required this.topContent,
      required this.hight,
      required this.width,
      required this.onContentSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
        mobile: _ContentHeaderMobile(
          topContent: topContent,
          onContentSelected: onContentSelected,
          width: width,
          hight: hight,
        ),
        desktop: _ContentHeaderDesktop(
          topContent: topContent,
          width: width,
          hight: hight,
          onContentSelected: onContentSelected,
        ));
  }
}

class _ContentHeaderMobile extends StatelessWidget {
  final List<Content> topContent;
  final Function(Content selectedContent) onContentSelected;
  final double hight;
  final double width;

  const _ContentHeaderMobile(
      {Key? key,
      required this.topContent,
      required this.onContentSelected,
      required this.hight,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Content featuredContent = topContent[Random().nextInt(topContent.length)];
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: hight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(featuredContent.headerImageURL),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          height: hight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.transparent,
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
        ),
        Positioned(
          bottom: 360,
          child: SizedBox(
            width: 250,
            child: Text(
              featuredContent.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ),
        Positioned(
          bottom: 310,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButton(
                icon: Icons.add,
                title: "List",
                onTap: () {},
              ),
              _PlayButton(
                  onPlayPressed: () => onContentSelected(featuredContent)),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: "Info",
                onTap: () {},
              ),
            ],
          ),
        ),
        Positioned(
          child: TopContentList(
            key: const PageStorageKey('top10'),
            title: "Top 10",
            contentList: topContent,
            onContentSelected: (content) => onContentSelected(content),
          ),
          left: 0,
          right: 0,
          bottom: 0,
        )
      ],
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final List<Content> topContent;
  final double hight;
  final double width;
  final double bottomOffset = 50;
  final Function(Content selectedContent) onContentSelected;

  const _ContentHeaderDesktop(
      {Key? key,
      required this.topContent,
      required this.hight,
      required this.width,
      required this.onContentSelected})
      : super(key: key);

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _videoController;
  bool _isMuted = true;
  late Content featuredContent;

  @override
  void initState() {
    featuredContent =
        widget.topContent[Random().nextInt(widget.topContent.length)];
    _videoController = VideoPlayerController.network(
      featuredContent.videoURL,
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0)
      ..play()
      ..setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.hight + widget.bottomOffset,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -1.0,
            child: AspectRatio(
              aspectRatio: _videoController.value.isInitialized
                  ? _videoController.value.aspectRatio
                  : 2.344,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black,
                    Colors.transparent,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60,
            right: 60,
            bottom: 400 + widget.bottomOffset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    featuredContent.title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  featuredContent.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ]),
                ),
                const SizedBox(height: 25),
                SizedBox(
                    width: 250,
                    height: 50,
                    child: _PlayButton(
                      onPlayPressed: () =>
                          widget.onContentSelected(featuredContent),
                    ))
              ],
            ),
          ),
          Positioned(
              bottom: 400 + widget.bottomOffset,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: IconButton(
                      icon: Icon(
                        _isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _videoController.setVolume(_isMuted ? 0 : 1);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      border: const Border(
                          left: BorderSide(color: Colors.white, width: 3)),
                    ),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            "6",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              )),
          Positioned(
            child: TopContentList(
              key: const PageStorageKey('top10'),
              title: "Top 10",
              contentList: widget.topContent,
              onContentSelected: (content) => widget.onContentSelected(content),
            ),
            bottom: widget.bottomOffset - 10,
            left: 0,
            right: 0,
          )
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final Function() onPlayPressed;

  const _PlayButton({Key? key, required this.onPlayPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onPlayPressed(),
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(15, 5, 20, 5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.play_arrow,
              size: 30,
              color: Colors.black,
            ),
            Text(
              "Play",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ));
  }
}
