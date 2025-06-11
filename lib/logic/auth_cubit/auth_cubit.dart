import 'dart:async';

import 'package:chat_app/features/auth/data/repositories/auth_repository.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  // ignore: unused_field
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _init();
  }
  void _init() {
    emit(state.copyWith(status: AuthStatus.initial));
    _authStateSubscription = _authRepository.authStateChanges.listen((
      user,
    ) async {
      if (user != null) {
        try {
          final userData = await _authRepository.getUserData(user.uid);
          emit(
            state.copyWith(status: AuthStatus.authenticated, user: userData),
          );
        } catch (e) {
          emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
        }
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    });
  }

  Future<void> signUp({
    required userName,
    required email,
    required phoneNumber,
    required password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final userData = await _authRepository.signUp(
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: userData));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signIn({required email, required password}) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final userData = await _authRepository.signIn(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: userData));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await _authRepository.signOut();

      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }
}
