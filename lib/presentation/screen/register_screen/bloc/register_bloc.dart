import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/data/repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  RegisterBloc(this.userRepository) : super(RegisterInitial()) {
    on<RegisterRequestedEvent>(_registerRequested);
    on<RegisterFormErrorEvent>(_formError);
    on<RegisterResetToInitial>(_resetToInitial);
  }

  void _registerRequested(RegisterRequestedEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(RegisterInLoadingProccess());
      final user = await userRepository.register(
        event.username,
        event.password,
        event.avatarId,
      );
      emit(RegisterSuccess(user));
    } on UserException catch (_) {
      emit(RegisterFailed(Texts.userWithThisUsernameAlreadyExists));
      return;
    } catch (e) {
      emit(RegisterFailed(Texts.errorOccuredCheckInternetConnection));
      return;
    }
  }

  void _formError(RegisterFormErrorEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterFailed(event.error));
  }

  void _resetToInitial(RegisterResetToInitial event, Emitter<RegisterState> emit) async {
    emit(RegisterInitial());
  }
}

sealed class RegisterEvent {}

final class RegisterRequestedEvent extends RegisterEvent {
  final String username;
  final String password;
  final String avatarId;
  RegisterRequestedEvent(this.username, this.password, this.avatarId);
}

final class RegisterFormErrorEvent extends RegisterEvent {
  String error;
  RegisterFormErrorEvent(this.error);
}

final class RegisterResetToInitial extends RegisterEvent {}

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterInLoadingProccess extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final User user;
  RegisterSuccess(this.user);
}

final class RegisterFailed extends RegisterState {
  final String error;
  RegisterFailed(this.error);
}
