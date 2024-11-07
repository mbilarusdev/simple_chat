import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/data/repository/user_repository.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final UserRepository userRepository;
  SearchUsersBloc(this.userRepository) : super(SearchUsersState.initial()) {
    on<SearchUsersRequested>(_searchUsers, transformer: debounceDroppable(const Duration(milliseconds: 200)));
  }

  void _searchUsers(SearchUsersRequested event, Emitter<SearchUsersState> emit) async {
    try {
      int usersPerPage = 10;
      final trimmedQuery = event.queryString.trim();

      // Сброс
      if (trimmedQuery.isEmpty) {
        emit(SearchUsersState.initial());
        return;
      }
      // Первый поиск
      if (trimmedQuery.isNotEmpty && trimmedQuery != state.lastQuery) {
        emit(SearchUsersState.loadMore([], usersPerPage, trimmedQuery));
        final List<User> users = await userRepository.findUsers(
          FindUsers(
            username: trimmedQuery,
            page: 1,
            perPage: usersPerPage,
          ),
        );
        emit(SearchUsersState.success(users, trimmedQuery));
        return;
      }
      // Загрузка по скроллу
      if (trimmedQuery.isNotEmpty &&
          trimmedQuery == state.lastQuery &&
          (state.users.length % usersPerPage == 0 || state.users.isEmpty)) {
        emit(SearchUsersState.loadMore(
          state.users,
          usersPerPage,
          trimmedQuery,
        ));
        final pageToLoad = (state.users.length ~/ usersPerPage) + 1;
        final List<User> users = await userRepository.findUsers(
          FindUsers(
            username: trimmedQuery,
            page: pageToLoad,
            perPage: usersPerPage,
          ),
        );
        emit(
          SearchUsersState.success(
            [...state.users, ...users],
            trimmedQuery,
          ),
        );
      }
    } catch (e, st) {
      print(e);
      print(st);
      emit(
        SearchUsersState.failed(
          'Ошибка поиска, проверьте соединение с интернетом',
          state.users,
          state.lastQuery,
        ),
      );
    }
  }
}

enum SearchUsersStateType { initial, loading, success, failed }

final class SearchUsersState {
  final SearchUsersStateType type;
  final String? error;
  final List<User> users;
  final int inLoading;
  final String? lastQuery;

  const SearchUsersState._({
    required this.type,
    this.error,
    this.users = const [],
    this.lastQuery,
    this.inLoading = 0,
  });

  factory SearchUsersState.initial() => const SearchUsersState._(
        type: SearchUsersStateType.initial,
      );

  factory SearchUsersState.failed(
    String error,
    List<User> users,
    String? lastQuery,
  ) =>
      SearchUsersState._(
        type: SearchUsersStateType.failed,
        error: error,
        lastQuery: lastQuery,
      );

  factory SearchUsersState.success(
    List<User> users,
    String lastQuery,
  ) =>
      SearchUsersState._(
        type: SearchUsersStateType.success,
        users: users,
        lastQuery: lastQuery,
      );

  factory SearchUsersState.loadMore(
    List<User> users,
    int inLoading,
    String lastQuery,
  ) =>
      SearchUsersState._(
        type: SearchUsersStateType.loading,
        users: users,
        inLoading: inLoading,
        lastQuery: lastQuery,
      );
}

sealed class SearchUsersEvent {}

final class SearchUsersRequested extends SearchUsersEvent {
  final String queryString;
  SearchUsersRequested(this.queryString);
}
