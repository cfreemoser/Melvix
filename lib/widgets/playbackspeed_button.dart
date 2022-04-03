// ignore_for_file: no_logic_in_create_state

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

@immutable
class PlayBackSpeedButton extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  PlayBackSpeedButton({Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  State<PlayBackSpeedButton> createState() => _PlayBackSpeedButtonState();
}

class _PlayBackSpeedButtonState extends State<PlayBackSpeedButton> {
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  _PlayBackSpeedButtonState();

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
            top: offset.dy - 150,
            right: 0,
            child: Container(
              height: 150,
              width: 600,
              color: const Color.fromRGBO(38, 38, 38, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: Text("Playbackspeed",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SpeedSlider(
                        hideSlider: hideSlider,
                        videoPlayerController: widget.videoPlayerController,
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  void hideSlider() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  @override
  void deactivate() {
    super.deactivate();

    hideSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (_) => hideSlider(),
      child: GestureDetector(
        onTap: () => setState(() {
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context)?.insert(_overlayEntry!);
        }),
        child: const Icon(
          Icons.speed,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}

class SpeedSlider extends StatefulWidget {
  final Function hideSlider;
  final VideoPlayerController videoPlayerController;

  SpeedSlider({
    Key? key,
    required this.hideSlider,
    required this.videoPlayerController,
  }) : super(key: key);

  @override
  State<SpeedSlider> createState() => _SpeedSliderState(videoPlayerController);
}

class _SpeedSliderState extends State<SpeedSlider> {
  final VideoPlayerController videoPlayerController;

  _SpeedSliderState(this.videoPlayerController);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.white,
                tickMarkShape:
                    const RoundSliderTickMarkShape(tickMarkRadius: 6),
                thumbShape: const _CustomSliderThumbCircle(thumbRadius: 16),
                inactiveTrackColor: Colors.grey,
                trackShape: const RectangularSliderTrackShape(),
                activeTrackColor: Colors.grey),
            child: Slider(
              value: playbackValueToSliderValue(
                  videoPlayerController.value.playbackSpeed),
              onChangeEnd: (_) => widget.hideSlider(),
              onChanged: (value) => setState(() {
                videoPlayerController
                    .setPlaybackSpeed(sliderValueToPlayback(value));
              }),
              divisions: 4,
              min: 0,
              max: 4,
              label:
                  "${sliderValueToPlayback(videoPlayerController.value.playbackSpeed)}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  5,
                  (index) => Text(
                        "${sliderValueToPlayback(index.toDouble())}x",
                        style: TextStyle(color: Colors.white),
                      )),
            ),
          ),
        ],
      ),
    );
  }

  double sliderValueToPlayback(double sliderValue) {
    switch (sliderValue.round()) {
      case 0:
        {
          return 0.25;
        }
      case 1:
        {
          return 0.75;
        }
      case 2:
        {
          return 1;
        }
      case 3:
        {
          return 1.25;
        }
      case 4:
        {
          return 1.5;
        }
    }
    return 1;
  }

  double playbackValueToSliderValue(double playbackValue) {
    if (playbackValue == 0.25) {
      return 0;
    }

    if (playbackValue == 0.75) {
      return 1;
    }

    if (playbackValue == 1) {
      return 2;
    }

    if (playbackValue == 1.25) {
      return 3;
    }

    return 4;
  }
}

class _CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const _CustomSliderThumbCircle({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 3 //Thumb Background Color
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius * .7, paint);
    canvas.drawCircle(center, (thumbRadius + 6) * .9, paint2);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
