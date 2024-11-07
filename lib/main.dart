import 'package:flutter/material.dart';
import 'package:simple_chat/app.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setOnErrorCallbacks();

  runApp(
    SimpleChatApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      secureStorage: SimpleChatSecureStorage(),
    ),
  );
}
