import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/theme.dart';

class OpaqueTextbutton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const OpaqueTextbutton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: UnitSystem.unitX7,
        child: Center(
          child: Text(
            text,
            style: SimpleChatFonts.boldText(),
          ),
        ),
      ),
    );
  }
}
