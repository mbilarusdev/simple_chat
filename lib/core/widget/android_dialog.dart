import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/theme.dart';

class AndroidDialog {
  static void show(
    BuildContext context,
    String? title,
    String? description, {
    Widget? customContent,
    VoidCallback? onYes,
    VoidCallback? onNo,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: SimpleChatColors.backgroundBlack,
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: EdgeInsets.all(UnitSystem.unitX2),
            child: customContent ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        title!,
                        style: SimpleChatFonts.mediumHeader(),
                      ),
                    ),
                    const SizedBox(height: UnitSystem.unit),
                    Flexible(
                      child: Text(
                        description!,
                        style: SimpleChatFonts.defaultText(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: onNo,
                          child: Text(
                            'Нет',
                            style: SimpleChatFonts.boldText(),
                          ),
                        ),
                        TextButton(
                          onPressed: onYes,
                          child: Text(
                            'Да',
                            style: SimpleChatFonts.boldText(SimpleChatColors.errorText),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
          ),
        );
      },
    );
  }
}
