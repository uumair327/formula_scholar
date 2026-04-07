import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Implementation of [AuthRepositoryPort] coordinating data sources.
///
/// Satisfies Golden Rule 5: Dependency Injection. Uses @LazySingleton
/// so `getIt` manages instantiation.
///
/// Catches exceptions thrown by adapters and maps them to typed [Failure]s
/// wrapped in [Result], consistent with all other repository implementations.
@LazySingleton(as: AuthRepositoryPort)
class AuthRepositoryImpl implements AuthRepositoryPort {
  final AuthDataSourcePort _remoteAdapter;

  AuthRepositoryImpl(this._remoteAdapter);

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteAdapter.signIn(
        email: email,
        password: password,
      );
      AppLogger.info(
        'SignIn succeeded in repository: ${user.uid}',
        tag: AppLogTags.authRepo,
      );
      return Success(user);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'SignIn failed in repository',
        error: e,
        stackTrace: stackTrace,
        tag: AppLogTags.authRepo,
      );
      return Error(
        AuthFailure(
          message: e is ServerException
              ? e.message
              : 'Invalid credentials. Please try again.',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    try {
      final user = await _remoteAdapter.signInWithGoogle();
      AppLogger.info(
        'SignInWithGoogle succeeded in repository: ${user.uid}',
        tag: AppLogTags.authRepo,
      );
      return Success(user);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'SignInWithGoogle failed in repository',
        error: e,
        stackTrace: stackTrace,
        tag: AppLogTags.authRepo,
      );
      return Error(
        AuthFailure(
          message: e is ServerException
              ? e.message
              : 'Google Sign-In failed. Please try again.',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<AuthUser>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteAdapter.signUp(
        name: name,
        email: email,
        password: password,
      );
      AppLogger.info(
        'SignUp succeeded in repository: ${user.uid}',
        tag: AppLogTags.authRepo,
      );
      return Success(user);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'SignUp failed in repository',
        error: e,
        stackTrace: stackTrace,
        tag: AppLogTags.authRepo,
      );
      return Error(
        AuthFailure(
          message: e is ServerException
              ? e.message
              : 'Registration failed. Please try again.',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteAdapter.signOut();
      AppLogger.info(
        'SignOut succeeded in repository',
        tag: AppLogTags.authRepo,
      );
      return const Success(null);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'SignOut failed in repository',
        error: e,
        stackTrace: stackTrace,
        tag: AppLogTags.authRepo,
      );
      return Error(
        AuthFailure(
          message: 'Failed to sign out. Please try again.',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AuthUser? get currentUser => _remoteAdapter.currentUser;

  @override
  Stream<AuthUser?> authStateChanges() => _remoteAdapter.authStateChanges();
}
