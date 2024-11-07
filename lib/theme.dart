import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers.dart';

class SimpleChatColors {
  static Color get backgroundBlack => const Color(0xFF333333);
  static Color get appBarBlack => Colors.black26;
  static Color get textBlack => const Color(0xFF333333);
  static Color get textLight => Colors.white;
  static Color get activeElementColor => Colors.deepOrange;
  static Color get lightElement => Colors.orange;
  static Color get secondary => Colors.orangeAccent;
  static Color get errorText => Colors.redAccent;
  static Color get warningText => Colors.orangeAccent;
}

class SimpleChatFonts {
  static TextStyle bigHeader([Color? color]) =>
      TextStyle(color: color ?? SimpleChatColors.textLight, fontWeight: FontWeight.w800, fontSize: 20.0);
  static TextStyle mediumHeader([Color? color]) =>
      TextStyle(color: color ?? SimpleChatColors.textLight, fontWeight: FontWeight.w800, fontSize: 16.0);
  static TextStyle defaultText([Color? color]) => TextStyle(color: color ?? SimpleChatColors.textLight, fontSize: 14.0);
  static TextStyle boldText([Color? color]) =>
      TextStyle(color: color ?? SimpleChatColors.textLight, fontWeight: FontWeight.w600, fontSize: 14.0);
  static TextStyle hintSmallText([Color? color]) =>
      TextStyle(color: color ?? SimpleChatColors.textLight, fontSize: 12.0);
  static TextStyle errorText() =>
      TextStyle(color: SimpleChatColors.errorText, fontWeight: FontWeight.w600, fontSize: 14.0);
  static TextStyle warningText() =>
      TextStyle(color: SimpleChatColors.errorText, fontWeight: FontWeight.w600, fontSize: 14.0);
}

class SimpleChatTheme {
  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        progressIndicatorTheme: ProgressIndicatorThemeData(color: SimpleChatColors.lightElement),
        scaffoldBackgroundColor: SimpleChatColors.backgroundBlack,
        appBarTheme: AppBarTheme(
          backgroundColor: SimpleChatColors.appBarBlack,
          titleTextStyle: SimpleChatFonts.bigHeader(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.resolveWith<TextStyle>((_) => SimpleChatFonts.boldText()),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (_) => SimpleChatColors.activeElementColor,
            ),
            minimumSize: WidgetStateProperty.resolveWith<Size>(
              (_) => Size(
                double.infinity,
                UnitSystem.unitX7,
              ),
            ),
          ),
        ),
      );
}
