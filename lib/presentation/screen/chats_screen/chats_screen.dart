import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/appbar_action_button.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';
import 'package:simple_chat/presentation/screen/chats_screen/bloc/chats_bloc.dart';
import 'package:simple_chat/presentation/screen/invites_screen/bloc/invites_bloc.dart';

import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

import 'widget/chat_tile.dart';

class ChatsScreen extends StatefulWidget {
  static const pathSegment = '/chats';
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return BaseScreenScaffold(
      title: Texts.chats,
      actions: [
        AppbarActionButton(
          icon: Icons.add,
          onPressed: () {
            context.goNamed(RouteNames.createChat);
          },
        )
      ],
      child: BlocConsumer<ChatsBloc, ChatsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.type == ChatsStateType.initial || (state.chats.isEmpty && state.inLoading != 0)) {
            return const Center(child: CircularProgressIndicator());
          }
          if ((state.chats.isEmpty && state.inLoading == 0)) {
            return Center(
              child: Text(
                'У вас пока нет чатов!',
                style: SimpleChatFonts.hintSmallText(),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: state.chats.length,
                  prototypeItem: state.chats.isNotEmpty ? ChatTile(chat: state.chats.first) : null,
                  itemBuilder: (context, index) {
                    return ChatTile(chat: state.chats[index]);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        if (_isBottom) {
          context.read<InvitesBloc>().add(InvitesReceive());
        }
      });

    super.initState();
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
