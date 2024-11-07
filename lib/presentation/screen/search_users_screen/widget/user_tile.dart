import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/bloc/pick_users_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/theme.dart';

class UserTile extends StatefulWidget {
  final User user;
  final List<User> pickedUsers;

  const UserTile({
    super.key,
    required this.user,
    required this.pickedUsers,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  List<User> pickedUsers = [];

  @override
  void initState() {
    pickedUsers = widget.pickedUsers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final avatar = user.profile!.avatar!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final bloc = context.read<PickUsersBloc>();
        pickedUsers = bloc.state.users;
        pickedUsers.contains(user) ? pickedUsers.remove(user) : pickedUsers.add(user);
        bloc.add(PickUsersRequested(pickedUsers));
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(UnitSystem.unit),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(64.0),
                  child: Image.memory(
                    width: 56,
                    height: 56,
                    prepareImage(avatar),
                    gaplessPlayback: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: user.isOnline ? Colors.lightGreenAccent[400] : Colors.grey,
                    borderRadius: BorderRadius.circular(60.0),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(width: UnitSystem.unit),
          Text(
            user.username,
            style: SimpleChatFonts.boldText(),
          ),
          const SizedBox(width: UnitSystem.unit),
          const Spacer(),
          pickedUsers.contains(user)
              ? Icon(
                  Icons.check_circle,
                  color: SimpleChatColors.activeElementColor,
                )
              : const Icon(
                  Icons.circle_outlined,
                  color: Colors.white,
                ),
          const SizedBox(width: UnitSystem.unit),
        ]),
      ),
    );
  }
}
