import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_chat/core/helpers.dart';

import '../../theme.dart';

class SimpleChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final bool nextFocus;
  final VoidCallback? onEditingComplete;
  final String? labelText;
  final Function(String)? onChanged;
  final IconData? suffixIcon;
  final bool autoFocus;
  const SimpleChatInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.focusNode,
    this.nextFocus = false,
    this.onEditingComplete,
    this.labelText,
    this.onChanged,
    this.suffixIcon,
    this.autoFocus = false,
  });

  @override
  State<SimpleChatInputField> createState() => _SimpleChatInputFieldState();
}

class _SimpleChatInputFieldState extends State<SimpleChatInputField> {
  bool hasText = false;
  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = widget.controller;
    final String? hintText = widget.hintText;
    final bool obscureText = widget.obscureText;
    final input = Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12.0)
          .copyWith(top: 2)
          .copyWith(right: obscureText || widget.suffixIcon != null ? 0 : 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 2),
        borderRadius: BorderRadius.circular(24.0),
        color: Colors.white,
      ),
      child: TextField(
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        controller: controller
          ..addListener(() {
            hasText = controller.text.trim().isNotEmpty;
            setState(() {});
          }),
        obscureText: visibility ? false : obscureText,
        obscuringCharacter: '•',
        cursorColor: SimpleChatColors.activeElementColor,
        style: SimpleChatFonts.defaultText(SimpleChatColors.textBlack),
        textAlignVertical: obscureText || widget.suffixIcon != null ? TextAlignVertical.center : null,
        textInputAction: widget.nextFocus ? TextInputAction.next : TextInputAction.done,
        onChanged: widget.onChanged,
        onEditingComplete: () {
          widget.onEditingComplete?.call();
          if (widget.nextFocus && hasText) {
            FocusScope.of(context).nextFocus();
          } else {
            if (Platform.isIOS) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            }
            if (Platform.isAndroid) {
              FocusScope.of(context).unfocus();
            }
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: SimpleChatFonts.defaultText(
            SimpleChatColors.textBlack.withOpacity(0.5),
          ),
          suffixIcon: _suffixIcon(),
        ),
      ),
    );
    if (widget.labelText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.labelText!, style: SimpleChatFonts.boldText()),
              SizedBox(height: UnitSystem.unitX4),
            ],
          ),
          input,
        ],
      );
    }
    return input;
  }

  Widget? _suffixIcon() {
    if (widget.obscureText) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          visibility = !visibility;
          setState(() {});
        },
        child: SizedBox(
          height: 48.0,
          width: 48.0,
          child: Icon(
            size: 24.0,
            visibility ? Icons.visibility : Icons.visibility_off,
            color: visibility ? SimpleChatColors.activeElementColor : Colors.black54,
          ),
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return SizedBox(
        height: 48.0,
        width: 48.0,
        child: Icon(
          size: 24.0,
          widget.suffixIcon,
          color: Colors.black54,
        ),
      );
    }
    return null;
  }
}
