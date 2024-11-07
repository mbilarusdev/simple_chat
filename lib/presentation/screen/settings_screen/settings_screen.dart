import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/core/widget/appbar_action_button.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';
import 'package:simple_chat/presentation/screen/login_screen/bloc/login_bloc.dart';
import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

class MySettingsScreen extends StatefulWidget {
  static const pathSegment = '/my_settings';
  const MySettingsScreen({super.key});

  @override
  State<MySettingsScreen> createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final avatar = (context.read<LoginBloc>().state as LoginSuccess).user.profile!.avatar;

    return BaseScreenScaffold(
      title: 'Настройки',
      actions: [
        AppbarActionButton(
          icon: Icons.logout,
          onPressed: () async {
            final loginBloc = context.read<LoginBloc>()..add(LogoutRequested());
            loginBloc.stream.firstWhere((state) => state is LoginInitial).then((_) {
              context.goNamed(RouteNames.login);
            });
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              context.goNamed(RouteNames.profile);
            },
            child: Container(
              padding: const EdgeInsets.all(UnitSystem.unit),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
              child: Row(children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: MemoryImage(prepareImage(avatar!)),
                ),
                const SizedBox(width: UnitSystem.unit),
                Text(
                  'Профиль',
                  style: SimpleChatFonts.boldText(),
                ),
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.goNamed(RouteNames.chatsSettings);
            },
            child: Container(
              padding: const EdgeInsets.all(UnitSystem.unit),
              height: 64.0,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
              child: Row(children: [
                Icon(
                  size: 24.0,
                  Icons.chat_bubble,
                  color: SimpleChatColors.textLight,
                ),
                const SizedBox(width: UnitSystem.unit),
                Text(
                  'Настройки чатов',
                  style: SimpleChatFonts.boldText(),
                ),
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.goNamed(RouteNames.otherSettings);
            },
            child: Container(
              padding: const EdgeInsets.all(UnitSystem.unit),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
              height: 64.0,
              child: Row(children: [
                Icon(
                  size: 24.0,
                  Icons.settings_suggest,
                  color: SimpleChatColors.textLight,
                ),
                const SizedBox(width: UnitSystem.unit),
                Text(
                  'Другие настройки',
                  style: SimpleChatFonts.boldText(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
