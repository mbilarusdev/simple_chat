import 'package:flutter/material.dart';

import '../../../core/widget/base_screen_scaffold.dart';

class MyChatSettingsScreen extends StatefulWidget {
  static const pathSegment = 'my_chat_settings';
  const MyChatSettingsScreen({super.key});

  @override
  State<MyChatSettingsScreen> createState() => _MyChatSettingsScreenState();
}

class _MyChatSettingsScreenState extends State<MyChatSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const BaseScreenScaffold(
      title: 'Настройки чатов',
      hasBackButton: true,
      child: Column(
        children: [],
      ),
    );
  }
}
