import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/data/model.dart';

class PickUsersBloc extends Bloc<PickUsersRequested, PickUsersState> {
  PickUsersBloc() : super(PickUsersState([])) {
    on<PickUsersRequested>(_pick);
  }

  void _pick(PickUsersRequested event, Emitter<PickUsersState> emit) => emit(PickUsersState(event.users));
}

final class PickUsersRequested {
  final List<User> users;
  PickUsersRequested(this.users);
}

final class PickUsersState {
  List<User> users;
  PickUsersState(this.users);
}
