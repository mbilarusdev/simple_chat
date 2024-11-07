import 'package:flutter/material.dart';

import '../../../core/widget/base_screen_scaffold.dart';

class OtherSettingsScreen extends StatefulWidget {
  static const pathSegment = 'other_settings';
  const OtherSettingsScreen({super.key});

  @override
  State<OtherSettingsScreen> createState() => _OtherSettingsScreenState();
}

class _OtherSettingsScreenState extends State<OtherSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const BaseScreenScaffold(
      title: 'Другие настройки',
      hasBackButton: true,
      child: Column(
        children: [],
      ),
    );
  }
}
