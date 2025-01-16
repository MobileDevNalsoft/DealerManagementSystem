import 'package:bloc/bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/repository/repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logger/logger.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  NavigatorService? navigator;
  AuthenticationBloc({Repository? repo, this.navigator})
      : _repo = repo!,
        super(AuthenticationState.initial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<ObscurePasswordTapped>(_onObscurePasswordTapped);
  }

  final Repository _repo;

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));
    await _repo.authenticateUser(event.username, event.password).then(
      (json) {
        if (json['response_code'] == 200) {
          emit(state.copyWith(
              authenticationStatus: AuthenticationStatus.success));
          getIt<SharedPreferences>().setString('user_name', event.username);
          getIt<SharedPreferences>().setStringList(
              'locations',
              List<String>.from(
                  (json['locations']).map((e) => e['location_name']).toList()));
          navigator!.pushReplacement('/home');
        } else if (json['response_code'] == 404) {
          emit(state.copyWith(
              authenticationStatus: AuthenticationStatus.invalidCredentials));
        } else {
          emit(state.copyWith(
              authenticationStatus: AuthenticationStatus.failure));
          Log.e(json);
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(
            state.copyWith(authenticationStatus: AuthenticationStatus.failure));
        Log.e(error);
      },
    );
  }

  void _onObscurePasswordTapped(
      ObscurePasswordTapped event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(obscure: !state.obscure!));
  }
}
