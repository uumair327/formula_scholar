import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

// ── State ──────────────────────────────────────────────────────────

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Cubit ──────────────────────────────────────────────────────────

/// Cubit managing authentication flows (login, signup, signout).
///
/// Satisfies Golden Rule 3: Cubit for simple state.
/// Satisfies Golden Rule 2 & 5: D.I. via @injectable, depends on
/// Use Cases, not repositories or implementations.
///
/// Uses [Result] pattern matching (consistent with DashboardCubit,
/// ProfileCubit) instead of raw try/catch.
@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;
  final GoogleSignInUseCase _googleSignIn;

  AuthCubit({
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required SignOutUseCase signOut,
    required GoogleSignInUseCase googleSignIn,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _googleSignIn = googleSignIn,
        super(const AuthState());

  /// Signs in the user via [SignInUseCase].
  ///
  /// Uses exhaustive `Result` pattern matching for typed error handling.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    AppLogger.info(
      'Sign-in attempted for: $email',
      tag: AppLogTags.authCubit,
    );
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signIn(email: email, password: password);

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Sign-in succeeded: ${data.uid}',
          tag: AppLogTags.authCubit,
        );
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: data,
        ));
      case Error(:final failure):
        AppLogger.error(
          'Sign-in failed: ${failure.message}',
          tag: AppLogTags.authCubit,
          error: failure.originalError,
          stackTrace: failure.stackTrace,
        );
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
    }
  }

  /// Signs in the user via Google Sign-In.
  Future<void> signInWithGoogle() async {
    AppLogger.info('Google sign-in attempted', tag: AppLogTags.authCubit);
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _googleSignIn();

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Google sign-in succeeded: ${data.uid}',
          tag: AppLogTags.authCubit,
        );
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: data,
        ));
      case Error(:final failure):
        // If the user simply closed the dialog, we might not want to show an error bar,
        // but for now we display 'Google sign-in was cancelled.' 
        AppLogger.error(
          'Google sign-in failed: ${failure.message}',
          tag: AppLogTags.authCubit,
          error: failure.originalError,
          stackTrace: failure.stackTrace,
        );
        emit(state.copyWith(
          // Return to unauthenticated state rather than error if cancelled, or keep error.
          status: failure.message.contains('cancelled') 
              ? AuthStatus.unauthenticated 
              : AuthStatus.error,
          errorMessage: failure.message.contains('cancelled')
              ? null
              : failure.message,
        ));
    }
  }

  /// Signs up the user via [SignUpUseCase].
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    AppLogger.info('Sign-up attempted for: $email', tag: AppLogTags.authCubit);
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signUp(name: name, email: email, password: password);

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Sign-up succeeded: ${data.uid}',
          tag: AppLogTags.authCubit,
        );
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: data,
        ));
      case Error(:final failure):
        AppLogger.error(
          'Sign-up failed: ${failure.message}',
          tag: AppLogTags.authCubit,
          error: failure.originalError,
          stackTrace: failure.stackTrace,
        );
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    AppLogger.info('Sign-out attempted', tag: AppLogTags.authCubit);
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signOut();

    switch (result) {
      case Success():
        AppLogger.info('Sign-out succeeded', tag: AppLogTags.authCubit);
        emit(const AuthState(status: AuthStatus.unauthenticated));
      case Error(:final failure):
        AppLogger.error(
          'Sign-out failed: ${failure.message}',
          tag: AppLogTags.authCubit,
          error: failure.originalError,
        );
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
    }
  }
}
