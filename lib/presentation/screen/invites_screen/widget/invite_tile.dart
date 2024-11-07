import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/data/model/chat_invite.dart';
import 'package:simple_chat/theme.dart';

import '../../../../core/widget/invite_dialog.dart';

class InviteTile extends StatefulWidget {
  final ChatInvite invite;

  const InviteTile({
    super.key,
    required this.invite,
  });

  @override
  State<InviteTile> createState() => _InviteTileState();
}

class _InviteTileState extends State<InviteTile> {
  @override
  Widget build(BuildContext context) {
    final invite = widget.invite;

    final chat = invite.chat;
    final chatImage = prepareImage(chat.image!);

    return GestureDetector(
      onTap: () {
        InviteDialog.show(context, invite);
      },
      child: Container(
        padding: const EdgeInsets.all(UnitSystem.unit),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Приглашение', style: SimpleChatFonts.defaultText()),
                Text(
                  invite.dateInfo,
                  style: SimpleChatFonts.defaultText(),
                ),
              ],
            ),
            const SizedBox(height: UnitSystem.unit),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(64.0),
                  child: Image.memory(
                    width: 56,
                    height: 56,
                    chatImage,
                    gaplessPlayback: true,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: UnitSystem.unit),
                Flexible(
                  child: Text(
                    chat.title,
                    style: SimpleChatFonts.boldText(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
