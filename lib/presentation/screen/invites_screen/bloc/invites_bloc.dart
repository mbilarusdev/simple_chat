import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simple_chat/data/model/chat_invite.dart';
import 'package:simple_chat/data/model/pagination_param.dart';
import 'package:simple_chat/data/repository/chat_repository.dart';

import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class InvitesBloc extends Bloc<InvitesEvent, InvitesState> {
  final ChatRepository chatRepository;
  InvitesBloc(this.chatRepository) : super(InvitesState.initial()) {
    on<InvitesReceive>(_receiveInvites, transformer: debounceDroppable(const Duration(milliseconds: 200)));
  }

  void _receiveInvites(InvitesReceive event, Emitter<InvitesState> emit) async {
    try {
      int invitesPerPage = 20;

      // Загрузка по скроллу
      if (event.isRefresh) {
        emit(InvitesState.initial());
      }
      if ((state.invites.length % invitesPerPage == 0 || state.invites.isEmpty)) {
        emit(InvitesState.loadMore(
          state.invites,
          invitesPerPage,
        ));
        final pageToLoad = (state.invites.length ~/ invitesPerPage) + 1;
        final List<ChatInvite> invites = await chatRepository.receiveInvites(
          PaginationParam(
            page: pageToLoad,
            perPage: invitesPerPage,
          ),
        );
        emit(InvitesState.success([...state.invites, ...invites]));
      }
    } catch (e, st) {
      print(e);
      print(st);
      emit(
        InvitesState.failed(
          'Ошибка поиска, проверьте соединение с интернетом',
          state.invites,
        ),
      );
    }
  }
}

enum InvitesStateType { initial, loading, success, failed }

final class InvitesState {
  final InvitesStateType type;
  final String? error;
  final List<ChatInvite> invites;
  final int inLoading;

  const InvitesState._({
    required this.type,
    this.error,
    this.invites = const [],
    this.inLoading = 0,
  });

  factory InvitesState.initial() => const InvitesState._(
        type: InvitesStateType.initial,
      );

  factory InvitesState.failed(
    String error,
    List<ChatInvite> invites,
  ) =>
      InvitesState._(
        type: InvitesStateType.failed,
        error: error,
        invites: invites,
      );

  factory InvitesState.success(
    List<ChatInvite> invites,
  ) =>
      InvitesState._(
        type: InvitesStateType.success,
        invites: invites,
      );

  factory InvitesState.loadMore(
    List<ChatInvite> invites,
    int inLoading,
  ) =>
      InvitesState._(
        type: InvitesStateType.loading,
        invites: invites,
        inLoading: inLoading,
      );
}

sealed class InvitesEvent {}

final class InvitesReceive extends InvitesEvent {
  bool isRefresh;
  InvitesReceive([this.isRefresh = false]);
}
