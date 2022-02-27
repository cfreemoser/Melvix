import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/vertical_icon_button.dart';
import 'package:video_player/video_player.dart';

class ContentHeader extends StatelessWidget {
  final Content featuredContent;

  const ContentHeader({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
        mobile: _ContentHeaderMobile(featuredContent: featuredContent),
        desktop: _ContentHeaderDesktop(featuredContent: featuredContent));
  }
}

class _ContentHeaderMobile extends StatelessWidget {
  final Content featuredContent;

  const _ContentHeaderMobile({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(featuredContent.headerImageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 500,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.transparent,
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
        ),
        Positioned(
          bottom: 110,
          child: SizedBox(
            width: 250,
            child: Text(
              featuredContent.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
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
              _PlayButton(),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: "Info",
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;

  const _ContentHeaderDesktop({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _videoController;
  bool _isMuted = true;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(
      widget.featuredContent.videoURL,
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0)
      ..play();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoController.value.isInitialized
                ? _videoController.value.aspectRatio
                : 2.344,
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : Image.asset(
                    widget.featuredContent.headerImageURL,
                    fit: BoxFit.cover,
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
            bottom: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    widget.featuredContent.title,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "TODO add discripton",
                  style: TextStyle(
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
                Row(
                  children: [
                    _PlayButton(),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _videoController.setVolume(_isMuted ? 0 : 1);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => log("played"),
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(15, 5, 20, 5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.play_arrow,
              color: Colors.black,
            ),
            Text(
              "Play",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ));
  }
}
