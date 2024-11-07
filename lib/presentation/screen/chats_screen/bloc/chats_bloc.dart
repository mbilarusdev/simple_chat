import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/data/model.dart';

import 'package:simple_chat/data/model/pagination_param.dart';
import 'package:simple_chat/data/repository/chat_repository.dart';

import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;
  ChatsBloc(this.chatRepository) : super(ChatsState.initial()) {
    on<ChatsReceive>(_receiveChats, transformer: debounceDroppable(const Duration(milliseconds: 200)));
  }

  void _receiveChats(ChatsReceive event, Emitter<ChatsState> emit) async {
    try {
      int chatsPerPage = 20;

      // Загрузка по скроллу
      if (event.isRefresh) {
        emit(ChatsState.initial());
      }
      if ((state.chats.length % chatsPerPage == 0 || state.chats.isEmpty)) {
        emit(ChatsState.loadMore(
          state.chats,
          chatsPerPage,
        ));
        final pageToLoad = (state.chats.length ~/ chatsPerPage) + 1;
        final List<Chat> chats = await chatRepository.getMyChats(
          PaginationParam(
            page: pageToLoad,
            perPage: chatsPerPage,
          ),
        );
        emit(ChatsState.success([...state.chats, ...chats]));
      }
    } catch (e, st) {
      print(e);
      print(st);
      emit(
        ChatsState.failed(
          'Ошибка поиска, проверьте соединение с интернетом',
          state.chats,
        ),
      );
    }
  }
}

enum ChatsStateType { initial, loading, success, failed }

final class ChatsState {
  final ChatsStateType type;
  final String? error;
  final List<Chat> chats;
  final int inLoading;

  const ChatsState._({
    required this.type,
    this.error,
    this.chats = const [],
    this.inLoading = 0,
  });

  factory ChatsState.initial() => const ChatsState._(
        type: ChatsStateType.initial,
      );

  factory ChatsState.failed(
    String error,
    List<Chat> chats,
  ) =>
      ChatsState._(
        type: ChatsStateType.failed,
        error: error,
        chats: chats,
      );

  factory ChatsState.success(
    List<Chat> chats,
  ) =>
      ChatsState._(
        type: ChatsStateType.success,
        chats: chats,
      );

  factory ChatsState.loadMore(
    List<Chat> chats,
    int inLoading,
  ) =>
      ChatsState._(
        type: ChatsStateType.loading,
        chats: chats,
        inLoading: inLoading,
      );
}

sealed class ChatsEvent {}

final class ChatsReceive extends ChatsEvent {
  bool isRefresh;
  ChatsReceive([this.isRefresh = false]);
}
