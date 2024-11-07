import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/bloc/image_picker_bloc.dart';
import 'package:simple_chat/core/bloc/pick_users_bloc.dart';

import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/android_dialog.dart';
import 'package:simple_chat/core/widget/avatar_picker.dart';

import 'package:simple_chat/core/widget/base_screen_scaffold.dart';
import 'package:simple_chat/core/widget/button.dart';
import 'package:simple_chat/core/widget/input_field.dart';
import 'package:simple_chat/presentation/screen/create_chat_screen/widget/contacts_picker.dart';
import 'package:simple_chat/data/model/chat.dart';
import 'package:simple_chat/data/repository/chat_repository.dart';
import 'package:simple_chat/presentation/screen/register_screen/widget/register_form.dart';
import 'package:simple_chat/router.dart';
import 'package:simple_chat/theme.dart';

import '../chats_screen/bloc/chats_bloc.dart';
import 'bloc/create_chat_bloc.dart';

class CreateChatScreen extends StatefulWidget {
  static const pathSegment = 'create';
  const CreateChatScreen({super.key});

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  late final TextEditingController titleController;
  late final TextEditingController inviteTextController;
  late final List<FocusNode> nodes;
  late final GlobalKey<AvatarPickerState> avatarPickerKey;

  @override
  void initState() {
    titleController = TextEditingController();
    inviteTextController = TextEditingController();
    avatarPickerKey = GlobalKey<AvatarPickerState>();
    nodes = [FocusNode(), FocusNode()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PickUsersBloc(),
        ),
        BlocProvider(
          create: (_) => CreateChatBloc(context.read<ChatRepository>()),
        )
      ],
      child: Builder(
        builder: (context) => BlocListener<CreateChatBloc, CreateChatState>(
          listener: (context, state) async {
            if (state is CreateChatSuccess) {
              final chatsBloc = context.read<ChatsBloc>()..add(ChatsReceive(true));
              await chatsBloc.stream.first;
              if (!context.mounted) return;
              context.goNamed(RouteNames.chatProcess, pathParameters: {'chat_id': state.chat.chatId!});
            }
          },
          child: BaseScreenScaffold(
            hasBackButton: true,
            onTapBackButton: () {
              FocusScope.of(context).unfocus();
              AndroidDialog.show(
                context,
                'Создание чата',
                'Вы действительно хотите приостановить создание чата?',
                onYes: () async {
                  final chatsBloc = context.read<ChatsBloc>()..add(ChatsReceive(true));
                  await chatsBloc.stream.first;
                  if (!context.mounted) return;
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pop(context);
                },
                onNo: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              );
            },
            title: 'Создание чата',
            child: Padding(
              padding: EdgeInsets.all(UnitSystem.unitX2).copyWith(
                bottom: UnitSystem.bottomPlatformPadding(),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        BlocBuilder<CreateChatBloc, CreateChatState>(builder: (context, state) {
                          return AvatarPicker(
                            key: avatarPickerKey,
                            // needDispose: state is! CreateChatSuccess,
                          );
                        }),
                        SizedBox(height: UnitSystem.unitX2),
                        SimpleChatInputField(
                          labelText: 'Название чата',
                          hintText: 'Введите название чата',
                          suffixIcon: Icons.title,
                          controller: titleController,
                          focusNode: nodes[0],
                        ),
                        SizedBox(height: UnitSystem.unitX2),
                        SimpleChatInputField(
                          labelText: 'Пригласительное письмо',
                          hintText: 'Введите пригласительное письмо',
                          suffixIcon: Icons.mail,
                          controller: inviteTextController,
                          focusNode: nodes[1],
                        ),
                        SizedBox(height: UnitSystem.unitX4),
                        BlocBuilder<PickUsersBloc, PickUsersState>(builder: (context, state) {
                          return ContactsPicker(pickedUsers: state.users);
                        }),
                        SizedBox(height: UnitSystem.unitX4),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: SimpleChatColors.backgroundBlack,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: UnitSystem.unitX2, top: UnitSystem.unitX2),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          BlocBuilder<CreateChatBloc, CreateChatState>(builder: (context, state) {
                            if (state is! CreateChatFailed) return const SizedBox.shrink();
                            return FailedWidget(error: state.error);
                          }),
                          const SizedBox(height: UnitSystem.unit),
                          SimpleChatButton(
                            text: 'Создать чат',
                            icon: Icons.create,
                            onTap: () => _createChat(context),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createChat(BuildContext context) {
    final imageBloc = avatarPickerKey.currentState!.imagePickerBloc;
    final pickedUsers = context.read<PickUsersBloc>().state.users;
    final chatBloc = context.read<CreateChatBloc>();
    String? error;

    if (imageBloc.state is! ImagePickerSuccess) {
      error ??= 'Необходимо выбрать картинку для чата';
    }
    if (titleController.text.trim().length < 3) {
      error ??= 'Название чата должно состоять как минимум из 3 символов';
    }
    if (pickedUsers.isEmpty) {
      error ??= 'Необходимо выбрать как минимум 1 контакт, для создания чата';
    }
    if (inviteTextController.text.trim().length > 200) {
      error ??=
          'Максимальная длинна пригласительного письма 200 символов, текущая ${inviteTextController.text.trim().length}';
    }
    if (error != null) {
      chatBloc.add(CreateChatFormFailed(error));
      return;
    }
    chatBloc.add(
      CreateChatRequested(
        Chat(
          title: titleController.text,
          imageId: (imageBloc.state as ImagePickerSuccess).imageModel.imageId!,
        ),
        pickedUsers,
        inviteTextController.text.trim(),
      ),
    );
  }
}
