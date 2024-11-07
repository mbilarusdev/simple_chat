import 'package:dio/dio.dart';

class MessageRepository {
  final Dio dio;
  const MessageRepository({required this.dio});
}

class _MessageRepositoryUrls {
  static String get message => '/message';
  static String get allMessagesInChat => '/message/all';
}
