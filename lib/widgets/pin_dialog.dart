import 'package:flutter/material.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PinDialog extends StatefulWidget {
  final int targetPin;
  final Function onSuccess;

  const PinDialog({Key? key, required this.targetPin, required this.onSuccess})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PinDialogState();
}

class PinDialogState extends State<PinDialog> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Constants.profiles_pin_text),
      backgroundColor: Constants.netflix_background,
      titleTextStyle: const TextStyle(
          color: Colors.white, fontFamily: "NetflixSans", fontSize: 20),
      actions: <Widget>[
        TextButton(
          child: const Text(Constants.profiles_forgot_text,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "NetflixSans",
                  fontSize: 16)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: PinCodeTextField(
        autofocus: true,
        hideCharacter: true,
        highlight: true,
        highlightColor: Colors.grey,
        defaultBorderColor: Colors.grey,
        hasTextBorderColor: Constants.netflix_background,
        pinBoxColor: Colors.white.withOpacity(0.4),
        maskCharacter: "*",
        maxLength: 4,
        pinBoxWidth: 50,
        pinBoxHeight: 64,
        hasUnderline: true,
        wrapAlignment: WrapAlignment.spaceAround,
        pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
        pinTextStyle: const TextStyle(fontSize: 22.0),
        pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.scalingTransition,
        pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
        highlightAnimationBeginColor: Colors.black,
        highlightAnimationEndColor: Colors.white12,
        keyboardType: TextInputType.number,
        hasError: hasError,
        onTextChanged: (text) {
          setState(() {
            var targetPin = widget.targetPin.toString();
            if (targetPin == text) {
              widget.onSuccess();
            } else {
              hasError = !targetPin.startsWith(text);
            }
          });
        },
      ),
    );
  }
}
