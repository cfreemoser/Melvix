import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/fullscreen_button.dart';
import 'package:netflix_gallery/widgets/volume_button.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final Content content;

  const Player({Key? key, required this.content}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      widget.content.videoURL,
    )
      ..initialize().then((_) {
        setState(() {
          setState(() {});
        });
      })
      ..setVolume(0)
      ..play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
                aspectRatio: _videoPlayerController.value.isInitialized
                    ? _videoPlayerController.value.aspectRatio
                    : 2.344,
                child: VideoPlayer(_videoPlayerController)),
          ),
          _overlayControl(
            controller: _videoPlayerController,
            content: widget.content,
          )
        ],
      ),
    );
  }
}

class _overlayControl extends StatefulWidget {
  final VideoPlayerController controller;
  final Content content;

  const _overlayControl({
    Key? key,
    required this.controller,
    required this.content,
  }) : super(key: key);

  @override
  State<_overlayControl> createState() => _overlayControlState();
}

class _overlayControlState extends State<_overlayControl> {
  bool _hideOverlay = false;
  double volume = 0;
  Timer? _timer;

  _showOverlay() {
    setState(() {
      _hideOverlay = false;
    });

    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideOverlay = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _desktopOverlay = Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 54),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => log("search"),
                  icon: Icon(Icons.arrow_back),
                  iconSize: 60,
                  color: Colors.white,
                ),
                Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => log("search"),
                  icon: Icon(Icons.flag),
                  iconSize: 60,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            color: Colors.black,
            child: Column(
              children: [
                VideoProgressIndicator(widget.controller, allowScrubbing: true),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => log("search"),
                          icon: Icon(Icons.play_arrow),
                          iconSize: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => log("search"),
                          icon: Icon(Icons.fast_rewind),
                          iconSize: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => log("search"),
                          icon: Icon(Icons.fast_forward_rounded),
                          iconSize: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        VolumeButton(
                          volume: volume,
                          onVolumeChanged: (double value) {
                            setState(() {
                              volume = value;
                              widget.controller.setVolume(value);
                              log(value.toString());
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                            child: Center(
                          child: Text(
                            widget.content.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                        const SizedBox(width: 16),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => {},
                          icon: Icon(Icons.fullscreen),
                          iconSize: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => log("search"),
                          icon: Icon(Icons.av_timer),
                          iconSize: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        FullscreenButton(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );

    var _mobileOverlay = GestureDetector(
        onTap: () => setState(() {
              _hideOverlay = true;
            }),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 54),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => log("search"),
                      icon: Icon(Icons.arrow_back),
                      iconSize: 60,
                      color: Colors.white,
                    ),
                    Expanded(
                        child: Text(
                      widget.content.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    )),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => log("search"),
                      icon: Icon(Icons.flag),
                      iconSize: 60,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 64, right: 64),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => log("search"),
                    icon: Icon(Icons.fast_rewind),
                    iconSize: 60,
                    color: Colors.white,
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => log("search"),
                    icon: Icon(Icons.play_arrow),
                    iconSize: 60,
                    color: Colors.white,
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => log("search"),
                    icon: Icon(Icons.fast_forward_rounded),
                    iconSize: 60,
                    color: Colors.white,
                  ),
                ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: Colors.black,
                child: Row(
                  children: [
                    VolumeButton(
                      volume: volume,
                      onVolumeChanged: (double value) {
                        setState(() {
                          volume = value;
                          widget.controller.setVolume(value);
                        });
                      },
                    ),
                    Expanded(
                        child: VideoProgressIndicator(widget.controller,
                            allowScrubbing: true)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => log("search"),
                      icon: Icon(Icons.av_timer),
                      iconSize: 60,
                      color: Colors.white,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => log("search"),
                      icon: Icon(Icons.fullscreen),
                      iconSize: 60,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));

    return MouseRegion(
      onHover: (event) => _showOverlay(),
      child: _hideOverlay
          ? Container()
          : AdaptiveLayout(mobile: _mobileOverlay, desktop: _desktopOverlay),
    );
  }
}