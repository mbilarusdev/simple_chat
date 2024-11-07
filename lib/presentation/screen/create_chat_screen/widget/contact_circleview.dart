import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/data/model/user.dart';
import 'package:simple_chat/theme.dart';

class ContactCircleview extends StatefulWidget {
  static const double size = 56;
  final User user;
  final double viewSize;

  const ContactCircleview({super.key, required this.user}) : viewSize = size;

  @override
  State<ContactCircleview> createState() => _ContactCircleviewState();
}

class _ContactCircleviewState extends State<ContactCircleview> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final avatar = prepareImage(user.profile!.avatar!);
    final username = user.username.length >= 10 ? '${user.username.substring(0, 9)}...' : user.username;
    return Container(
      padding: const EdgeInsets.only(left: UnitSystem.unit),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(64.0),
            child: Image.memory(
              width: widget.viewSize,
              height: widget.viewSize,
              avatar,
              gaplessPlayback: true,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: UnitSystem.unit),
          Text(
            username,
            style: SimpleChatFonts.boldText(),
          ),
        ],
      ),
    );
  }
}
