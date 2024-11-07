import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/data/repository/chat_repository.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  final ChatRepository chatRepository;
  CreateChatBloc(this.chatRepository) : super(CreateChatInitial()) {
    on<CreateChatRequested>(_createChat);
    on<CreateChatFormFailed>(_formFailed);
  }

  void _createChat(CreateChatRequested event, Emitter<CreateChatState> emit) async {
    try {
      final invites = await chatRepository.createChat(CreateChat(
        chat: event.chat,
        inviteeIds: event.invitees.map((user) => user.userId).toList(),
        inviteText: event.inviteText,
      ));
      emit(CreateChatSuccess(invites.first.chat));
    } catch (e) {
      emit(CreateChatFailed('Ошибка при создании чата, проверьте соединение с интернетом'));
    }
  }

  void _formFailed(CreateChatFormFailed event, Emitter<CreateChatState> emit) {
    emit(CreateChatFailed(event.error));
  }
}

sealed class CreateChatEvent {}

final class CreateChatRequested extends CreateChatEvent {
  final Chat chat;
  final List<User> invitees;
  final String? inviteText;
  CreateChatRequested(
    this.chat,
    this.invitees,
    this.inviteText,
  );
}

final class CreateChatFormFailed extends CreateChatEvent {
  String error;
  CreateChatFormFailed(this.error);
}

sealed class CreateChatState {}

final class CreateChatInitial extends CreateChatState {}

final class CreateChatInLoadingProcess extends CreateChatState {}

final class CreateChatSuccess extends CreateChatState {
  Chat chat;
  CreateChatSuccess(this.chat);
}

final class CreateChatFailed extends CreateChatState {
  String error;
  CreateChatFailed(this.error);
}
