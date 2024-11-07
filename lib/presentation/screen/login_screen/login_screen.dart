import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/base_screen_scaffold.dart';
import 'package:simple_chat/core/widget/button.dart';
import 'package:simple_chat/core/widget/opaque_textbutton.dart';

import 'package:simple_chat/presentation/screen/login_screen/bloc/login_bloc.dart';
import 'package:simple_chat/router.dart';

import 'widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const pathSegment = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final List<FocusNode> nodes;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    nodes = [
      FocusNode(),
      FocusNode(),
    ];
    context.read<LoginBloc>().add(LoginCheckRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginSuccess) {
        context.goNamed(RouteNames.chats);
      }
    }, builder: (context, state) {
      if (state is LoginInCheckProgress || state is LoginSuccess) {
        return const Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return BaseScreenScaffold(
        title: Texts.login,
        child: Padding(
          padding: EdgeInsets.all(UnitSystem.unitX2).copyWith(
            bottom: UnitSystem.bottomPlatformPadding(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoginForm(
                state: state,
                usernameController: usernameController,
                passwordController: passwordController,
                nodes: nodes,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SimpleChatButton(text: Texts.requestLogin, onTap: _onPressedLogin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OpaqueTextbutton(
                        text: Texts.goToRegister,
                        onTap: () {
                          context.read<LoginBloc>().add(LogoutRequested());
                          context.goNamed(RouteNames.register);
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
    });
  }

  void _onPressedLogin() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    bool notAllFieldsEntered = username.isEmpty || password.isEmpty;
    final loginBloc = context.read<LoginBloc>();
    if (loginBloc.state is LoginInLoadingProccess) return;
    String? error;

    if (notAllFieldsEntered) {
      error ??= Texts.enteredNotAllFields;
      if (username.isEmpty) {
        nodes[0].requestFocus();
      } else if (password.isEmpty) {
        nodes[1].requestFocus();
      }
    }

    if (error != null) return loginBloc.add(LoginFormErrorEvent(error));

    loginBloc.add(LoginRequested(
      username,
      password,
    ));
  }
}
