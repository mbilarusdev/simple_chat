import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/helpers/secure_storage.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/core/ws/messages/handshake.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketConnecter {
  final SimpleChatSecureStorage _secureStorage;

  WebSocketConnecter(SimpleChatSecureStorage secureStorage) : _secureStorage = secureStorage;
  late final _baseUrl = baseUrl(isWs: true);

  Stream<dynamic>? _webSocketStream;
  StreamSubscription<dynamic>? _messageStreamSubscription;
  final StreamController<Map<String, dynamic>> _messagesController = StreamController<Map<String, dynamic>>.broadcast();
  Future<Stream<Map<String, dynamic>>?> get wsStream async {
    final connected = await _connect();
    if (!connected) return null;
    return _messagesController.stream;
  }

  String typeKey = 'message_type';
  Future<bool> _connect() async {
    final completer = Completer<bool>();
    StreamSubscription<dynamic>? handshakeSub;
    var ws = WebSocketChannel.connect(Uri.parse('$_baseUrl/ws/connect'));
    await ws.ready;
    _webSocketStream = ws.stream.asBroadcastStream();

    handshakeSub = _webSocketStream!.listen((handshake) async {
      if (HandshakeMessage.fromMap(jsonDecode(handshake) as Map<String, dynamic>).isSuccess == true) {
        if (_messageStreamSubscription != null) {
          await _messageStreamSubscription?.cancel();
        }
        _messageStreamSubscription = _webSocketStream?.listen((rawMessage) {
          final mapMessage = jsonDecode(rawMessage) as Map<String, dynamic>;
          _messagesController.add(mapMessage);
        });
        print('Websocket connected');
        handshakeSub?.cancel();
        completer.complete(true);
      } else {
        _messageStreamSubscription?.cancel();
        _messageStreamSubscription = null;
        handshakeSub?.cancel();
        await ws.sink.close();
        completer.complete(false);
      }
    });
    ws.sink.add(jsonEncode(HandshakeMessage(token: await _secureStorage.readAuthorizationToken()).toMap()));
    return completer.future;
  }
}

extension WsConnect on BuildContext {
  Future<void> ws(void Function(Map<String, dynamic> message) listener) async {
    (read<WebSocketConnecter>().wsStream).then((streamOrNull) => streamOrNull?.listen(listener));
  }
}
