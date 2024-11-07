import 'package:flutter/material.dart';

import '../../theme.dart';

class SimpleChatButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final bool isSecondColor;
  final IconData? icon;
  const SimpleChatButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.width = double.infinity,
      this.isSecondColor = false,
      this.icon});

  @override
  State<SimpleChatButton> createState() => _SimpleChatButtonState();
}

class _SimpleChatButtonState extends State<SimpleChatButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle bStyle = Theme.of(context).elevatedButtonTheme.style!;
    if (widget.isSecondColor) {
      bStyle = bStyle.copyWith(backgroundColor: WidgetStatePropertyAll(SimpleChatColors.lightElement));
    }
    return ElevatedButton(
      style: bStyle,
      onPressed: widget.onTap,
      child: Row(
        mainAxisAlignment: widget.icon != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: SimpleChatFonts.boldText(),
          ),
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              color: Colors.white,
              size: 24.0,
            ),
          ]
        ],
      ),
    );
  }
}
