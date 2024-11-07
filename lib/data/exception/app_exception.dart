import 'dart:io';

import 'package:dio/dio.dart';

enum AppExceptionType { unauthorized, notFound, unprocessableEntity, other }

class AppException implements Exception {
  AppExceptionType type;
  Object? error;
  StackTrace? stackTrace;
  AppException._(this.type, this.error, this.stackTrace);
  factory AppException.unauthorized([Object? error, StackTrace? stackTrace]) => AppException._(
        AppExceptionType.unauthorized,
        error,
        stackTrace,
      );
  factory AppException.notFound([Object? error, StackTrace? stackTrace]) => AppException._(
        AppExceptionType.notFound,
        error,
        stackTrace,
      );
  factory AppException.other([Object? error, StackTrace? stackTrace]) => AppException._(
        AppExceptionType.other,
        error,
        stackTrace,
      );
  factory AppException.unprocessableEntity([Object? error, StackTrace? stackTrace]) => AppException._(
        AppExceptionType.unprocessableEntity,
        error,
        stackTrace,
      );
}

void handleDioAppErrors(DioException e, StackTrace stackTrace) {
  final sCode = e.response?.statusCode;
  if (sCode == HttpStatus.unauthorized) {
    throw AppException.unauthorized(e, stackTrace);
  }
  if (sCode == HttpStatus.notFound) {
    throw AppException.notFound(e, stackTrace);
  }
  if (sCode == HttpStatus.unprocessableEntity) {
    throw AppException.unprocessableEntity(e, stackTrace);
  }
  throw AppException.other(e, stackTrace);
}
