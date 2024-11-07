import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/core/widget/dismiss_keyboard.dart';
import 'package:simple_chat/core/ws/websocket_connector.dart';
import 'package:simple_chat/data/repository/chat_repository.dart';
import 'package:simple_chat/data/repository/image_repository.dart';
import 'package:simple_chat/presentation/screen/chats_screen/bloc/chats_bloc.dart';

import 'package:simple_chat/presentation/screen/login_screen/bloc/login_bloc.dart';
import 'package:simple_chat/presentation/screen/register_screen/bloc/register_bloc.dart';
import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

import 'core/widget/proxy/network.dart';
import 'data/repository/user_repository.dart';
import 'presentation/screen/invites_screen/bloc/invites_bloc.dart';

class SimpleChatApp extends StatefulWidget {
  final SimpleChatSecureStorage secureStorage;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const SimpleChatApp({super.key, required this.scaffoldMessengerKey, required this.secureStorage});

  @override
  State<SimpleChatApp> createState() => _SimpleChatAppState();
}

class _SimpleChatAppState extends State<SimpleChatApp> {
  @override
  Widget build(BuildContext context) {
    final dio = baseDio(secureStorage: widget.secureStorage);
    // Провайдер репозиториев
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => UserRepository(
            dio: dio,
            secureStorage: widget.secureStorage,
          ),
        ),
        RepositoryProvider(
          create: (_) => ImageRepository(dio: dio),
        ),
        RepositoryProvider(
          create: (_) => ChatRepository(dio: dio),
        ),
        RepositoryProvider(
          create: (_) => WebSocketConnecter(widget.secureStorage),
        ),
      ],
      child: Builder(
        // Провайдер бизнес-логики
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => RegisterBloc(context.read<UserRepository>()),
            ),
            BlocProvider(
              create: (_) => LoginBloc(context.read<UserRepository>()),
            ),
            BlocProvider(
              create: (_) => InvitesBloc(context.read<ChatRepository>())..add(InvitesReceive(true)),
            ),
            BlocProvider(
              create: (_) => ChatsBloc(context.read<ChatRepository>())..add(ChatsReceive(true)),
            ),
          ],
          child: Builder(
            builder: (context) {
              // Скрывает клавиатуру при клике вне TextField
              return DismissKeyboard(
                // Inherited widget проверки соединения с сетью
                //
                // взаимодейстует с `SimpleChatSnackBar` приложения и `BaseScreenScaffold`
                child: NetworkInherit(
                  notifier: NetworkModel(context, Connectivity()),
                  child:
                      // Inherited widget соединения с webSocket
                      //
                      // Используется в `NavigationScaffold`, там управляется
                      // connect и disconnect, а так же на всех экранах, где
                      // используется webSocket, устанавливаются прослушки:
                      //
                      // ```dart
                      // WebsocketConnectInherit.of(context).webSocket.stream.listen((message) {
                      // ...any_code...
                      // });
                      // ```

                      // Приложение
                      MaterialApp.router(
                    scaffoldMessengerKey: widget.scaffoldMessengerKey,
                    debugShowCheckedModeBanner: false,
                    theme: SimpleChatTheme.themeData,
                    routeInformationProvider: goRouter.routeInformationProvider,
                    routeInformationParser: goRouter.routeInformationParser,
                    routerDelegate: goRouter.routerDelegate,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
