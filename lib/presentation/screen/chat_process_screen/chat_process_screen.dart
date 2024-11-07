import 'package:flutter/material.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';

class ChatProcessScreen extends StatefulWidget {
  static const pathSegment = ':$chatIdKey/process';
  static const chatIdKey = 'chat_id';
  final String chatId;
  const ChatProcessScreen({super.key, required this.chatId});

  @override
  State<ChatProcessScreen> createState() => _ChatProcessScreenState();
}

class _ChatProcessScreenState extends State<ChatProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return const BaseScreenScaffold(
      title: 'Чат',
      hasBackButton: true,
      child: Column(
        children: [],
      ),
    );
  }
}
