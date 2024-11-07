import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/bloc/image_picker_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/avatar_picker.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';
import 'package:simple_chat/core/widget/button.dart';
import 'package:simple_chat/core/widget/opaque_textbutton.dart';
import 'package:simple_chat/presentation/screen/register_screen/widget/register_form.dart';
import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

import 'bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  static const pathSegment = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordRepeatController;
  late final List<FocusNode> nodes;
  late final GlobalKey<AvatarPickerState> avatarPickerKey;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    passwordRepeatController = TextEditingController();
    avatarPickerKey = GlobalKey<AvatarPickerState>();
    nodes = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenScaffold(
      title: Texts.register,
      child: Padding(
        padding: EdgeInsets.all(UnitSystem.unitX2).copyWith(
          bottom: UnitSystem.bottomPlatformPadding(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegisterForm(
              avatarPickerKey: avatarPickerKey,
              usernameController: usernameController,
              passwordController: passwordController,
              passwordRepeatController: passwordRepeatController,
              nodes: nodes,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Texts.acceptPersonalData,
                  style: SimpleChatFonts.hintSmallText(),
                ),
                SizedBox(height: UnitSystem.unitX2),
                SimpleChatButton(text: Texts.createAccount, onTap: _onPressedRegister),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OpaqueTextbutton(
                      text: Texts.alreadyHaveAnAccount,
                      onTap: () {
                        context.read<RegisterBloc>().add(RegisterResetToInitial());
                        context.goNamed(RouteNames.login);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedRegister() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String passwordRepeat = passwordRepeatController.text.trim();
    bool notAllFieldsEntered = username.isEmpty || password.isEmpty || passwordRepeat.isEmpty;
    final registerBloc = context.read<RegisterBloc>();
    final imageBloc = avatarPickerKey.currentState!.imagePickerBloc;
    if (registerBloc.state is RegisterInLoadingProccess) return;
    String? error;

    if (notAllFieldsEntered) {
      error ??= Texts.enteredNotAllFields;
      if (username.isEmpty) {
        nodes[0].requestFocus();
      } else if (password.isEmpty) {
        nodes[1].requestFocus();
      } else if (passwordRepeat.isEmpty) {
        nodes[2].requestFocus();
      }
    }

    bool passwordsTheSame = password == passwordRepeat;
    if (imageBloc.state is! ImagePickerSuccess) {
      error ??= Texts.needPickAvatar;
    }

    if (!passwordsTheSame) {
      error ??= Texts.passwordsNotTheSame;
    }

    bool usernameInvalid = username.length < 3;
    if (usernameInvalid) {
      error ??= Texts.usernameRequirements;
    }

    bool passwordInvalid = password.length < 8;
    if (passwordInvalid) {
      error ??= Texts.passwordRequirements;
    }

    if (error != null) return registerBloc.add(RegisterFormErrorEvent(error));
    registerBloc.add(RegisterRequestedEvent(
      username,
      password,
      (imageBloc.state as ImagePickerSuccess).imageModel.imageId!,
    ));
  }
}
