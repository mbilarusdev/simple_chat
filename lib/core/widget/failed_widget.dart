import 'package:flutter/material.dart';
import 'package:simple_chat/theme.dart';

class FailedWidget extends StatelessWidget {
  final String error;
  const FailedWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            error,
            style: SimpleChatFonts.errorText(),
          ),
        ),
      ],
    );
  }
}
