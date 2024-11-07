import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/bloc/pick_users_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/button.dart';
import 'package:simple_chat/data/repository.dart';
import 'package:simple_chat/presentation/screen/search_users_screen/widget/search_users_list.dart';

import 'bloc/search_users_bloc.dart';
import '../../../core/widget/base_screen_scaffold.dart';
import '../../../core/widget/input_field.dart';
import '../../../core/widget/selected_contacts_widget.dart';

class SearchUsersScreen extends StatefulWidget {
  static const pathSegment = 'users_search';
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  late final TextEditingController findController;
  late final SearchUsersBloc searchUsersBloc;
  late final ScrollController scrollController;

  @override
  void initState() {
    findController = TextEditingController();
    scrollController = ScrollController()
      ..addListener(() {
        if (_isBottom) {
          searchUsersBloc.add(
            SearchUsersRequested(
              findController.text.trim(),
            ),
          );
        }
      });

    super.initState();
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        searchUsersBloc = SearchUsersBloc(context.read<UserRepository>());
        return searchUsersBloc;
      },
      child: BaseScreenScaffold(
        title: 'Выбор контактов чата',
        hasBackButton: context.watch<PickUsersBloc>().state.users.isEmpty,
        onTapBackButton: () {
          FocusScope.of(context).requestFocus(FocusNode());
          context.pop();
        },
        child: Padding(
          padding: EdgeInsets.all(UnitSystem.unitX2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<PickUsersBloc, PickUsersState>(
                listener: (conext, state) {},
                builder: (context, state) {
                  if (state.users.isEmpty) return const SizedBox.shrink();

                  return SelectedContactsWidget(
                    contacts: state.users,
                  );
                },
              ),
              SimpleChatInputField(
                labelText: 'Поиск пользователей',
                hintText: 'Введите запрос по username',
                controller: findController,
                suffixIcon: Icons.search,
                onChanged: (str) {
                  searchUsersBloc.add(SearchUsersRequested(findController.text));
                },
              ),
              const SizedBox(height: UnitSystem.unit),
              BlocConsumer<SearchUsersBloc, SearchUsersState>(
                listener: (conext, state) {},
                builder: (context, state) {
                  return Expanded(
                    child: SearchUsersList(
                      scrollController: scrollController,
                      findedUsers: state.users,
                    ),
                  );
                },
              ),
              const SizedBox(height: UnitSystem.unit),
              BlocConsumer<PickUsersBloc, PickUsersState>(
                listener: (conext, state) {},
                builder: (context, state) {
                  if (state.users.isEmpty) return const SizedBox.shrink();
                  return SimpleChatButton(
                    text: 'Подтвердить выбор',
                    icon: Icons.check_box_outlined,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      context.pop();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
