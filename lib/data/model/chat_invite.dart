import 'package:simple_chat/data/model.dart';

class ChatInvite {
  final User invitee;
  final User inviter;
  final Chat chat;
  final String? inviteText;
  final DateTime creationDate;
  ChatInvite({
    required this.invitee,
    required this.inviter,
    required this.chat,
    this.inviteText,
    required this.creationDate,
  });

  ChatInvite copyWith({
    User? invitee,
    User? inviter,
    Chat? chat,
    String? inviteText,
    DateTime? creationDate,
  }) {
    return ChatInvite(
      invitee: invitee ?? this.invitee,
      inviter: inviter ?? this.inviter,
      chat: chat ?? this.chat,
      inviteText: inviteText ?? this.inviteText,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'invitee': invitee.toMap(),
      'inviter': inviter.toMap(),
      'chat': chat.toMap(),
      'invite_text': inviteText,
      'creation_date': creationDate.toUtc().toIso8601String()
    };
  }

  factory ChatInvite.fromMap(Map<String, dynamic> map) {
    return ChatInvite(
      invitee: User.fromMap(map['invitee'] as Map<String, dynamic>),
      inviter: User.fromMap(map['inviter'] as Map<String, dynamic>),
      chat: Chat.fromMap(map['chat'] as Map<String, dynamic>),
      inviteText: map['invite_text'] as String?,
      creationDate: DateTime.parse(map['creation_date'] as String).toLocal(),
    );
  }

  @override
  String toString() =>
      'ChatInvite(invitee: $invitee, inviter: $inviter, chat: $chat, invite_text: $inviteText, creation_date: $creationDate)';

  @override
  bool operator ==(covariant ChatInvite other) {
    if (identical(this, other)) return true;

    return other.invitee == invitee &&
        other.inviter == inviter &&
        other.chat == chat &&
        other.inviteText == inviteText &&
        other.creationDate == creationDate;
  }

  String get dateInfo => 'Создано ${creationDate.day.toString().padLeft(
        2,
        '0',
      )}.${creationDate.month.toString().padLeft(
        2,
        '0',
      )} в ${creationDate.hour.toString().padLeft(
        2,
        '0',
      )}:${creationDate.minute.toString().padLeft(
        2,
        '0',
      )}';

  @override
  int get hashCode => invitee.hashCode ^ inviter.hashCode ^ chat.hashCode ^ inviteText.hashCode ^ creationDate.hashCode;
}
