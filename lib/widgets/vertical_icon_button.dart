import 'package:flutter/material.dart';

class VerticalIconButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData icon;
  final double? size;
  final bool enabled;

  const VerticalIconButton(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.icon,
      this.size,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enabled) {
          onTap();
        }
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: size,
            color: enabled ? Colors.white : Colors.grey,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: enabled ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
