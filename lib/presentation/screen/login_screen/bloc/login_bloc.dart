import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/data/exception/app_exception.dart';
import 'package:simple_chat/data/model/user.dart';
import 'package:simple_chat/data/repository/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  LoginBloc(this.userRepository) : super(LoginInCheckProgress()) {
    on<LoginRequested>(_loginRequested);
    on<LoginFormErrorEvent>(_loginFormError);
    on<LoginCheckRequested>(_loginCheckRequested);
    on<LogoutRequested>(_logoutRequested);
  }

  void _loginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    try {
      if (state is! LoginInLoadingProccess) {
        emit(LoginInLoadingProccess());
        final user = await userRepository.login(
          event.username,
          event.password,
          event.passwordType,
        );
        emit(LoginSuccess(user));
      }
    } on AppException catch (e) {
      if (e.type == AppExceptionType.unauthorized) {
        emit(LoginFailed(Texts.incorrectDataEntered));
      } else {
        emit(LoginFailed(Texts.errorOccuredCheckInternetConnection));
      }
      return;
    } catch (e) {
      emit(LoginFailed(Texts.errorOccuredCheckInternetConnection));
      return;
    }
  }

  void _logoutRequested(LogoutRequested event, Emitter<LoginState> emit) async {
    try {
      if (state is! LogoutInLoadingProccess) {
        emit(LogoutInLoadingProccess());
        await userRepository.logout();
        emit(LoginInitial());
      }
    } catch (_) {}
  }

  void _loginCheckRequested(LoginCheckRequested event, Emitter<LoginState> emit) async {
    try {
      final user = await userRepository.getUser();
      emit(LoginSuccess(user));
    } catch (_) {
      emit(LoginInitial());
    }
  }

  void _loginFormError(LoginFormErrorEvent event, Emitter<LoginState> emit) async {
    emit(LoginFailed(event.error));
  }
}

sealed class LoginEvent {}

final class LoginRequested extends LoginEvent {
  final String username;
  final String password;
  final PasswordType passwordType;
  LoginRequested(this.username, this.password, {this.passwordType = PasswordType.standart});
}

final class LoginCheckRequested extends LoginEvent {}

final class LoginFormErrorEvent extends LoginEvent {
  final String error;
  LoginFormErrorEvent(this.error);
}

final class LogoutRequested extends LoginEvent {}

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginInCheckProgress extends LoginState {}

final class LoginInLoadingProccess extends LoginState {}

final class LogoutInLoadingProccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;
  LoginFailed(this.error);
}

final class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);
}
