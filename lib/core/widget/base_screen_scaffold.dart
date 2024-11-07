import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers.dart';

import 'proxy/network.dart';

class BaseScreenScaffold extends StatefulWidget {
  final Widget child;
  final String? title;
  final List<Widget> actions;
  final bool hasBackButton;
  final VoidCallback? onTapBackButton;
  const BaseScreenScaffold(
      {super.key,
      required this.title,
      required this.child,
      this.actions = const [],
      this.hasBackButton = false,
      this.onTapBackButton});

  @override
  State<BaseScreenScaffold> createState() => _BaseScreenScaffoldState();
}

class _BaseScreenScaffoldState extends State<BaseScreenScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.title == null
          ? null
          : AppBar(
              actions: [
                ...widget.actions,
                widget.actions.isNotEmpty ? const SizedBox(width: 12.0) : const SizedBox.shrink(),
              ],
              automaticallyImplyLeading: false,
              title: Row(children: [
                if (widget.hasBackButton) ...[
                  if (Platform.isAndroid)
                    GestureDetector(
                        onTap: _backTap,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  if (Platform.isIOS)
                    GestureDetector(
                        onTap: _backTap,
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        )),
                  const SizedBox(width: UnitSystem.unit),
                ],
                Text(
                  widget.title!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
                _networkIndicatorOrEmptyBox(),
              ]),
            ),
      body: widget.child,
    );
  }

  Widget _networkIndicatorOrEmptyBox() {
    if (hasNetwork) {
      return const SizedBox.shrink();
    } else {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 12),
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
  }

  bool? _hasNetwork;
  bool get hasNetwork => _hasNetwork ?? true;

  @override
  void didChangeDependencies() {
    _hasNetwork = NetworkInherit.of(context).current;
    super.didChangeDependencies();
  }

  void _backTap() {
    if (widget.onTapBackButton == null) {
      context.pop();
    }
    widget.onTapBackButton?.call();
  }
}
