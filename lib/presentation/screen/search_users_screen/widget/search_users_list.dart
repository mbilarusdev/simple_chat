import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/bloc/pick_users_bloc.dart';
import 'package:simple_chat/data/model.dart';

import 'user_tile.dart';

class SearchUsersList extends StatefulWidget {
  final List<User> findedUsers;
  final ScrollController scrollController;
  const SearchUsersList({
    super.key,
    required this.findedUsers,
    required this.scrollController,
  });

  @override
  State<SearchUsersList> createState() => _SearchUsersListState();
}

class _SearchUsersListState extends State<SearchUsersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: true,
      controller: widget.scrollController,
      padding: EdgeInsets.zero,
      itemCount: widget.findedUsers.length,
      itemBuilder: (context, index) => UserTile(
        user: widget.findedUsers[index],
        pickedUsers: context.read<PickUsersBloc>().state.users,
      ),
    );
  }
}
