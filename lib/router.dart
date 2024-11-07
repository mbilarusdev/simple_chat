import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/widget/navigation_scaffold.dart';
import 'package:simple_chat/presentation/screen/chat_process_screen/chat_process_screen.dart';
import 'package:simple_chat/presentation/screen/create_chat_screen/create_chat_screen.dart';
import 'package:simple_chat/presentation/screen/login_screen/login_screen.dart';
import 'package:simple_chat/presentation/screen/chat_settings_screen/chat_settings_screen.dart';
import 'package:simple_chat/presentation/screen/chats_screen/chats_screen.dart';
import 'package:simple_chat/presentation/screen/invites_screen/invites_screen.dart';
import 'package:simple_chat/presentation/screen/profile_screen/profile_screen.dart';
import 'package:simple_chat/presentation/screen/settings_screen/settings_screen.dart';
import 'package:simple_chat/presentation/screen/other_settings_screen/other_settings_screen.dart';
import 'package:simple_chat/presentation/screen/register_screen/register_screen.dart';

import 'core/bloc/pick_users_bloc.dart';
import 'presentation/screen/search_users_screen/search_users_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _myChatsKey = GlobalKey<NavigatorState>(debugLabel: 'myChats');
final _myInvitesKey = GlobalKey<NavigatorState>(debugLabel: 'myInvites');
final _mySettingsKey = GlobalKey<NavigatorState>(debugLabel: 'mySettings');

class RouteNames {
  static const String register = 'register';
  static const String login = 'login';
  static const String chats = 'chats';
  static const String createChat = 'createChat';
  static const String createChatSearchContacts = 'createChatSearchContacts';
  static const String chatProcess = 'chatProcess';
  static const String invites = 'invites';
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String chatsSettings = 'chatsSettings';
  static const String otherSettings = 'otherSettings';
}

final goRouter = GoRouter(
  initialLocation: LoginScreen.pathSegment,
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Регистрация
    GoRoute(
      name: RouteNames.register,
      path: RegisterScreen.pathSegment,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RegisterScreen(),
      ),
    ),

    // Вход
    GoRoute(
      name: RouteNames.login,
      path: LoginScreen.pathSegment,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginScreen(),
      ),
    ),

    // После входа
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return SimpleChatInAppNavigationScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Чаты
        StatefulShellBranch(
          navigatorKey: _myChatsKey,
          routes: [
            GoRoute(
              name: RouteNames.chats,
              path: ChatsScreen.pathSegment,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ChatsScreen(),
              ),
              routes: [
                // Экран процесса чата
                GoRoute(
                  name: RouteNames.chatProcess,
                  path: ChatProcessScreen.pathSegment,
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: ChatProcessScreen(
                      chatId: state.pathParameters[ChatProcessScreen.chatIdKey] as String,
                    ),
                  ),
                ),

                // Экран создания чата
                GoRoute(
                    name: RouteNames.createChat,
                    path: CreateChatScreen.pathSegment,
                    pageBuilder: (context, state) => const NoTransitionPage(
                          child: CreateChatScreen(),
                        ),
                    routes: [
                      // Экран поиска контактов
                      GoRoute(
                        name: RouteNames.createChatSearchContacts,
                        path: SearchUsersScreen.pathSegment,
                        pageBuilder: (context, state) {
                          return NoTransitionPage(
                            child: BlocProvider.value(
                              value: state.extra as PickUsersBloc,
                              child: const SearchUsersScreen(),
                            ),
                          );
                        },
                      ),
                    ]),
              ],
            ),
          ],
        ),

        // Уведомления
        StatefulShellBranch(
          navigatorKey: _myInvitesKey,
          routes: [
            GoRoute(
              name: RouteNames.invites,
              path: InvitesScreen.pathSegment,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: InvitesScreen(),
              ),
            ),
          ],
        ),

        // Настройки
        StatefulShellBranch(
          navigatorKey: _mySettingsKey,
          routes: [
            GoRoute(
              name: RouteNames.settings,
              path: MySettingsScreen.pathSegment,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MySettingsScreen(),
              ),
              routes: [
                // Настройки профиля
                GoRoute(
                  name: RouteNames.profile,
                  path: ProfileScreen.pathSegment,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ProfileScreen(),
                  ),
                ),

                // Настройки чатов
                GoRoute(
                  name: RouteNames.chatsSettings,
                  path: MyChatSettingsScreen.pathSegment,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: MyChatSettingsScreen(),
                  ),
                ),

                // Другие настройки
                GoRoute(
                  name: RouteNames.otherSettings,
                  path: OtherSettingsScreen.pathSegment,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: OtherSettingsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
