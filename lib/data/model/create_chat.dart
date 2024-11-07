import 'package:flutter/foundation.dart';

import 'chat.dart';

class CreateChat {
  final Chat chat;
  final List<String> inviteeIds;
  final String? inviteText;
  CreateChat({
    required this.chat,
    required this.inviteeIds,
    this.inviteText,
  });

  CreateChat copyWith({
    Chat? chat,
    List<String>? inviteeIds,
    String? inviteText,
  }) {
    return CreateChat(
      chat: chat ?? this.chat,
      inviteeIds: inviteeIds ?? this.inviteeIds,
      inviteText: inviteText ?? this.inviteText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'chat': chat.toMap(), 'invitee_ids': inviteeIds, 'invite_text': inviteText};
  }

  factory CreateChat.fromMap(Map<String, dynamic> map) {
    return CreateChat(
      chat: Chat.fromMap(map['chat'] as Map<String, dynamic>),
      inviteeIds: List<String>.from(
        (map['invitee_ids'] as List<String>),
      ),
      inviteText: map['invite_text'] as String?,
    );
  }

  @override
  String toString() => 'CreateChat(chat: $chat, invitee_ids: $inviteeIds, invite_text: $inviteText)';

  @override
  bool operator ==(covariant CreateChat other) {
    if (identical(this, other)) return true;

    return other.chat == chat && listEquals(other.inviteeIds, inviteeIds) && other.inviteText == inviteText;
  }

  @override
  int get hashCode => chat.hashCode ^ inviteeIds.hashCode ^ inviteText.hashCode;
}
