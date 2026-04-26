import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/auth/domain/domain.dart';

void main() {
  group('GetCurrentAuthUserUseCase', () {
    test('returns the current user from the repository', () {
      const user = AuthUser(
        uid: 'user-1',
        email: 'scholar@example.com',
        displayName: 'Scholar',
      );
      const repository = _FakeAuthRepository(currentUser: user);
      const useCase = GetCurrentAuthUserUseCase(repository);

      expect(useCase(), user);
    });
  });
}

class _FakeAuthRepository implements AuthRepositoryPort {
  const _FakeAuthRepository({AuthUser? currentUser})
    : _currentUser = currentUser;
  final AuthUser? _currentUser;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Stream<AuthUser?> authStateChanges() => const Stream<AuthUser?>.empty();

  @override
  Future<Result<void>> deleteAccount() async => const Success(null);

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async =>
      const Success(null);

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<Result<AuthUser>> signInWithGoogle() async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> signOut() async => const Success(null);

  @override
  Future<Result<AuthUser>> signUp({
    required String name,
    required String email,
    required String password,
  }) async => throw UnimplementedError();
}
