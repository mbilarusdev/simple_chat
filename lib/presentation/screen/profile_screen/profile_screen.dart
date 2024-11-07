import 'package:flutter/material.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  static const pathSegment = 'profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const BaseScreenScaffold(
      title: 'Профиль',
      hasBackButton: true,
      child: Column(
        children: [],
      ),
    );
  }
}
