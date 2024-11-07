import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/invite_dialog.dart';
import 'package:simple_chat/core/ws/websocket_connector.dart';
import 'package:simple_chat/data/model/chat_invite.dart';
import 'package:simple_chat/presentation/screen/chats_screen/bloc/chats_bloc.dart';
import 'package:simple_chat/presentation/screen/invites_screen/bloc/invites_bloc.dart';
import 'package:simple_chat/theme.dart';

class SimpleChatInAppNavigationScaffold extends StatefulWidget {
  const SimpleChatInAppNavigationScaffold({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('SimpleChatInAppNavigationScaffold'));
  final StatefulNavigationShell navigationShell;

  @override
  State<SimpleChatInAppNavigationScaffold> createState() => _SimpleChatInAppNavigationScaffoldState();
}

class _SimpleChatInAppNavigationScaffoldState extends State<SimpleChatInAppNavigationScaffold> {
  void _goBranch(int index) async {
    if (widget.navigationShell.currentIndex == index) return;

    if (index == 0) {
      final invitesBloc = context.read<ChatsBloc>();
      invitesBloc.add(ChatsReceive(true));
      await invitesBloc.stream.first;
    } else if (index == 1) {
      final invitesBloc = context.read<InvitesBloc>();
      invitesBloc.add(InvitesReceive(true));
      await invitesBloc.stream.first;
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (_) => const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          backgroundColor: SimpleChatColors.appBarBlack,
          selectedIndex: widget.navigationShell.currentIndex,
          overlayColor: WidgetStateProperty.resolveWith<Color>((_) => SimpleChatColors.activeElementColor),
          indicatorColor: SimpleChatColors.activeElementColor,
          destinations: [
            NavigationDestination(
              label: Texts.chats,
              selectedIcon: const Icon(
                Icons.chat_bubble,
                color: Colors.white,
              ),
              icon: const Icon(
                Icons.chat_bubble,
                color: Colors.white,
              ),
            ),
            const NavigationDestination(
              label: 'Уведомления',
              selectedIcon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
            const NavigationDestination(
              label: 'Настройки',
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }

  @override
  void initState() {
    context.ws((message) {
      if (message['message_type'] == 'chat_invite') {
        InviteDialog.show(context, ChatInvite.fromMap(message['message']));
      }
    });
    super.initState();
  }
}
