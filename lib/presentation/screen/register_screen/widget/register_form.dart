import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers/padding.dart';
import 'package:simple_chat/core/helpers/texts.dart';
import 'package:simple_chat/core/widget/avatar_picker.dart';
import 'package:simple_chat/core/widget/input_field.dart';
import 'package:simple_chat/data/repository.dart';
import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

import '../../login_screen/bloc/login_bloc.dart';
import '../bloc/register_bloc.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<AvatarPickerState> avatarPickerKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordRepeatController;
  final List<FocusNode> nodes;
  const RegisterForm({
    super.key,
    required this.avatarPickerKey,
    required this.usernameController,
    required this.passwordController,
    required this.passwordRepeatController,
    required this.nodes,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final nodes = widget.nodes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarPicker(key: widget.avatarPickerKey, needDispose: context.watch<RegisterBloc>().state is! RegisterSuccess),
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
          nextFocus: true,
        ),
        SizedBox(height: UnitSystem.unitX2),
        SimpleChatInputField(
          controller: widget.passwordRepeatController,
          labelText: Texts.passwordRepeat,
          hintText: Texts.enterPasswordRepeat,
          obscureText: true,
          focusNode: nodes[2],
        ),
        SizedBox(height: UnitSystem.unitX2),
        BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterSuccess) {
              final loginBloc = context.read<LoginBloc>()
                ..add(LoginRequested(state.user.username, state.user.passwordHash, passwordType: PasswordType.hash));
              await loginBloc.stream.firstWhere((state) => state is LoginSuccess);
              if (!context.mounted) return;
              context.goNamed(RouteNames.login);
            }
          },
          builder: (context, state) {
            if (state is RegisterFailed) {
              return FailedWidget(error: state.error);
            }
            if (state is RegisterInLoadingProccess) {
              return const CircularProgressIndicator();
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}

class FailedWidget extends StatelessWidget {
  final String error;
  const FailedWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            error,
            style: SimpleChatFonts.errorText(),
          ),
        ),
      ],
    );
  }
}
