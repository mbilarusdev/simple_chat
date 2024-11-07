import 'package:flutter/material.dart';
import 'package:simple_chat/main.dart';

class SimpleChatSnackbar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? show(
      {required String text, Duration duration = const Duration(seconds: 2)}) {
    return scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.orangeAccent,
        duration: duration,
        content: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            text,
            style: const TextStyle(
              color: Color(
                0xFF333333,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
