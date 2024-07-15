import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_auth_bloc/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription authSubscription;
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthState.unKnown()) {
    authSubscription = authRepository.user.listen(
      (fbAuth.User? user) {
        add(AuthStateChangedEvent(user));
      },
    );
    on<AuthStateChangedEvent>((event, emit) {
      if (event.user != null) {
        emit(state.copyWith(
            authStatus: AuthStatus.authenticated, user: event.user));
      } else {
        emit(
            state.copyWith(authStatus: AuthStatus.unauthenticated, user: null));
      }
    });

    on<SignoutRequestedEvent>(
      (event, emit) async {
        await authRepository.signOut();
      },
    );
  }
}
