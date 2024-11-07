import 'package:flutter/material.dart';

void setOnErrorCallbacks() {
  WidgetsBinding.instance.platformDispatcher.onError = (exception, stack) {
    debugPrint('$exception\n$stack');
    return true;
  };

  FlutterError.onError = (errorDetails) {
    debugPrint('${errorDetails.exception}\n${errorDetails.stack}');
  };
}
