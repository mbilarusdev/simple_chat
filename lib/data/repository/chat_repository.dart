import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simple_chat/data/exception.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/data/model/chat_invite.dart';
import 'package:simple_chat/data/model/pagination_param.dart';

class ChatRepository {
  final Dio dio;
  const ChatRepository({required this.dio});

  Future<List<ChatInvite>> createChat(CreateChat chatInfo) async {
    List<ChatInvite>? invites;
    try {
      invites = ((await dio.post<List>(
        _ChatRepositoryUrls.chat,
        data: jsonEncode(chatInfo.toMap()),
      ))
              .data!)
          .map((inviteMap) => ChatInvite.fromMap(inviteMap as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, st) {
      print(e);
      print(st);
      handleDioAppErrors(e, st);
    } catch (e, st) {
      print(e);
      print(st);
      throw AppException.other(e, st);
    }
    return invites!;
  }

  Future<List<Chat>> getMyChats([PaginationParam? param]) async {
    List<Chat>? chats;
    try {
      chats = ((await dio.get<List>(
        _ChatRepositoryUrls.allUserChats,
        data: param != null ? jsonEncode(param.toMap()) : null,
      ))
              .data!)
          .map((chatMap) => Chat.fromMap(chatMap as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, st) {
      print(e);
      print(st);
      handleDioAppErrors(e, st);
    } catch (e, st) {
      throw AppException.other(e, st);
    }
    return chats!;
  }

  Future<List<ChatInvite>> receiveInvites([PaginationParam? param]) async {
    List<ChatInvite>? invites;
    try {
      invites = ((await dio.get<List>(
        _ChatRepositoryUrls.allUserChatOutgoingInvites,
        data: param != null ? jsonEncode(param.toMap()) : null,
      ))
              .data!)
          .map((inviteMap) => ChatInvite.fromMap(inviteMap as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, st) {
      print(e);
      print(st);
      handleDioAppErrors(e, st);
    } catch (e, st) {
      print(e);
      print(st);
      throw AppException.other(e, st);
    }
    return invites!;
  }
}

class _ChatRepositoryUrls {
  static String get chat => '/chat';
  static String get allUserChats => '/chat/all';
  static String get allUserChatOutgoingInvites => '/chat/invite/all';
  static String get acceptInvite => '/chat/invite/accept';
  static String get declineInvite => 'chat/invite/decline';
}
