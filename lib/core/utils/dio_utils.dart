import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../helpers/secure_storage.dart';

String baseUrl({bool isWs = false}) {
  const port = 8080;
  if (Platform.isAndroid) return '${isWs ? 'ws' : 'http'}://10.0.2.2:$port';
  return '${isWs ? 'ws' : 'http'}://localhost:$port';
}

Dio baseDio({required SimpleChatSecureStorage secureStorage}) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(minutes: 10),
    baseUrl: baseUrl(),
    responseType: ResponseType.json,
  ))
    ..interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data != null) {
            if (response.data is String) {
              response.data = jsonDecode(response.data);
            }
            if (response.data is Map) {
              response.data = response.data as Map<String, dynamic>;
            }
            if (response.data is List) {
              response.data = (response.data as List).cast<Map<String, dynamic>>();
            }
          }

          await secureStorage.saveAuthorizationToken(response.headers.value(HttpHeaders.authorizationHeader));
          handler.next(response);
        },
        onRequest: (options, handler) async {
          final token = await secureStorage.readAuthorizationToken();

          if (token != null) {
            options.headers.addAll({
              HttpHeaders.authorizationHeader: token,
            });
          }
          handler.next(options);
        },
      ),
    );
}
