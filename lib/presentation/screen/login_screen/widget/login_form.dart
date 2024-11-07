import 'package:flutter/material.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/input_field.dart';
import 'package:simple_chat/presentation/screen/register_screen/widget/register_form.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final LoginState state;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final List<FocusNode> nodes;
  const LoginForm({
    super.key,
    required this.state,
    required this.usernameController,
    required this.passwordController,
    required this.nodes,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final nodes = widget.nodes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SimpleChatInputField(
          controller: widget.usernameController,
          labelText: Texts.username,
          hintText: Texts.enterUsername,
          focusNode: nodes[0],
          nextFocus: true,
        ),
        SizedBox(height: UnitSystem.unitX2),
        SimpleChatInputField(
          controller: widget.passwordController,
          labelText: Texts.password,
          hintText: Texts.enterPassword,
          obscureText: true,
          focusNode: nodes[1],
        ),
        SizedBox(height: UnitSystem.unitX2),
        if (state is LoginFailed) FailedWidget(error: state.error),
        if (state is LoginInLoadingProccess) const CircularProgressIndicator(),
      ],
    );
  }
}
