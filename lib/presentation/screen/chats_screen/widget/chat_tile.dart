import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  const ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(RouteNames.chatProcess, pathParameters: {'chat_id': chat.chatId!});
      },
      child: Container(
        padding: const EdgeInsets.all(UnitSystem.unit),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(64.0),
              child: Image.memory(
                width: 56,
                height: 56,
                prepareImage(chat.image!),
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
      ),
    );
  }
}
