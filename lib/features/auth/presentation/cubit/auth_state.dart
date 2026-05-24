import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    Object? errorMessage = unset,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: identical(errorMessage, unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
