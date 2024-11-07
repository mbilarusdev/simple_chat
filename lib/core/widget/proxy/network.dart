import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:simple_chat/core/widget/snackbar.dart';
import 'package:simple_chat/main.dart';

class NetworkModel extends ChangeNotifier {
  bool? current;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  NetworkModel(BuildContext context, Connectivity connectivity) {
    connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
      final netEnabled = result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi);
      _notify(netEnabled);
    });
  }

  void _notify(
    bool isConnected,
  ) {
    bool reconnected = isConnected == true && current == false;
    bool disconnected = isConnected == false;

    if (reconnected) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      SimpleChatSnackbar.show(text: 'Интернет соединение возобновилось!');
    }
    if (disconnected) {
      HapticFeedback.heavyImpact();
      SimpleChatSnackbar.show(text: 'Отсутствует интернет соединение!');
    }

    current = isConnected;
    notifyListeners();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }
}

class NetworkInherit extends InheritedNotifier<NetworkModel> {
  const NetworkInherit({
    super.key,
    required super.child,
    required NetworkModel notifier,
  }) : super(notifier: notifier);

  static NetworkModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NetworkInherit>()!.notifier!;
  }

  static NetworkModel get(BuildContext context) {
    return context.getInheritedWidgetOfExactType<NetworkInherit>()!.notifier!;
  }
}
