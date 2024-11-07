import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers/padding.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/data/model/chat_invite.dart';
import 'package:simple_chat/theme.dart';

import 'android_dialog.dart';

class InviteDialog {
  static void show(BuildContext context, ChatInvite chatInvite) {
    AndroidDialog.show(
      context,
      null,
      null,
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(64.0),
            child: Image.memory(
              width: 56,
              height: 56,
              prepareImage(chatInvite.chat.image!),
              gaplessPlayback: true,
              fit: BoxFit.cover,
            ),
          ),
          Flexible(
            child: Text(
              chatInvite.chat.title,
              style: SimpleChatFonts.mediumHeader(),
            ),
          ),
          const SizedBox(height: UnitSystem.unit),
          Flexible(
            child: Text(
              (chatInvite.inviteText?.trim().isEmpty ?? true)
                  ? '${chatInvite.inviter.username} приглашает вас'
                  : chatInvite.inviteText!,
              style: SimpleChatFonts.defaultText(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: Text(
                  'Отклонить',
                  style: SimpleChatFonts.boldText(SimpleChatColors.errorText),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Принять',
                  style: SimpleChatFonts.boldText(SimpleChatColors.activeElementColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
