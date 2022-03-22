import 'package:flutter/material.dart';

class VerticalIconButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData icon;
  final double? size;

  const VerticalIconButton(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.icon,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          Icon(
            icon,
            size: size,
            color: Colors.white,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
