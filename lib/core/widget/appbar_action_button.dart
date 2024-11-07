import 'package:flutter/material.dart';
import 'package:simple_chat/theme.dart';

class AppbarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const AppbarActionButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: SimpleChatColors.activeElementColor,
      child: IconButton(
        iconSize: 26,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
