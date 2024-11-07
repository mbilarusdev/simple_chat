import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';
import 'package:simple_chat/presentation/screen/invites_screen/bloc/invites_bloc.dart';
import 'package:simple_chat/theme.dart';

import 'widget/invite_tile.dart';

class InvitesScreen extends StatefulWidget {
  static const pathSegment = '/invites';
  const InvitesScreen({super.key});

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen> {
  late final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return BaseScreenScaffold(
      title: 'Уведомления',
      child: BlocConsumer<InvitesBloc, InvitesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.type == InvitesStateType.initial || (state.invites.isEmpty && state.inLoading != 0)) {
            return const Center(child: CircularProgressIndicator());
          }
          if ((state.invites.isEmpty && state.inLoading == 0)) {
            return Center(
              child: Text(
                'У вас пока нет уведомлений!',
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
                  itemCount: state.invites.length,
                  prototypeItem: state.invites.isNotEmpty ? InviteTile(invite: state.invites.first) : null,
                  itemBuilder: (context, index) {
                    return InviteTile(invite: state.invites[index]);
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
