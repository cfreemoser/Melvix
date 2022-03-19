import 'dart:async';

import 'package:flutter/material.dart';

@immutable
class VolumeButton extends StatefulWidget {
  final Function(double value) onVolumeChanged;
  final double volume;

  const VolumeButton({Key? key, required this.onVolumeChanged, this.volume = 0})
      : super(key: key);

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  OverlayEntry? _overlayEntry;
  double currentValue = 1;
  Timer? _timer;
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
            left: offset.dx + 20,
            top: offset.dy - 150,
            child: Container(
                height: 150,
                width: 20,
                color: Colors.blueAccent,
                child: _verticalSlider(
                    volume: widget.volume,
                    onVolumeChanged: widget.onVolumeChanged,
                    onExit: hideSlider))));
  }

  void hideSlider() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 1), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  void deactivate() {
    super.deactivate();

    hideSlider();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      }),
      onDoubleTap: () => setState(() {
        widget.onVolumeChanged(widget.volume == 0 ? 1 : 0);
      }),
      child: Icon(
        widget.volume == 0 ? Icons.volume_mute : Icons.volume_up,
        color: Colors.white,
        size: 60,
      ),
    );
  }
}

class _verticalSlider extends StatefulWidget {
  final Function onExit;
  final Function(double value) onVolumeChanged;
  final double volume;

  const _verticalSlider(
      {Key? key,
      required this.onExit,
      required this.onVolumeChanged,
      required this.volume})
      : super(key: key);

  @override
  State<_verticalSlider> createState() => _verticalSliderState();
}

class _verticalSliderState extends State<_verticalSlider> {
  double currentValue = 0;

  @override
  // ignore: must_call_super
  void initState() {
    setState(() {
      currentValue = widget.volume;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: 3,
        child: Material(
          color: Colors.grey,
          child: MouseRegion(
            onExit: (event) => widget.onExit(),
            child: Slider(
              onChangeEnd: widget.onExit(),
              onChanged: (value) => setState(() {
                currentValue = value;
                widget.onVolumeChanged(value);
              }),
              value: currentValue,
            ),
          ),
        ));
  }
}
