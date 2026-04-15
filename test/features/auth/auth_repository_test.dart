import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/features/auth/domain/entities/auth_user.dart';
import 'package:formula_scholar/features/auth/domain/ports/auth_repository_port.dart';
import 'package:formula_scholar/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:formula_scholar/features/auth/domain/ports/auth_data_source_port.dart';

// ---------- Fakes ----------

class FakeAuthDataSource implements AuthDataSourcePort {
  AuthUser? fakeUser;
  Exception? errorToThrow;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    return fakeUser!;
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    return fakeUser!;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    if (errorToThrow != null) throw errorToThrow!;
    return fakeUser!;
  }

  @override
  Future<void> signOut() async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<void> deleteAccount() async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  AuthUser? get currentUser => fakeUser;

  @override
  Stream<AuthUser?> authStateChanges() => Stream.value(fakeUser);
}

// ---------- Tests ----------

void main() {
  late FakeAuthDataSource fakeDataSource;
  late AuthRepositoryPort repository;

  final testUser = const AuthUser(
    uid: 'test-uid',
    email: 'test@example.com',
    displayName: 'Test User',
    emailVerified: true,
  );

  setUp(() {
    fakeDataSource = FakeAuthDataSource();
    repository = AuthRepositoryImpl(fakeDataSource);
  });

  group('AuthRepositoryImpl', () {
    group('signIn', () {
      test('returns Success with AuthUser on success', () async {
        fakeDataSource.fakeUser = testUser;

        final result = await repository.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isA<Success<AuthUser>>());
        final success = result as Success<AuthUser>;
        expect(success.data.uid, 'test-uid');
        expect(success.data.email, 'test@example.com');
      });

      test('returns Error with AuthFailure on exception', () async {
        fakeDataSource.errorToThrow = Exception('Network error');

        final result = await repository.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isA<Error<AuthUser>>());
        final error = result as Error<AuthUser>;
        expect(error.failure, isA<AuthFailure>());
      });
    });

    group('signOut', () {
      test('returns Success on success', () async {
        final result = await repository.signOut();
        expect(result, isA<Success<void>>());
      });

      test('returns Error on failure', () async {
        fakeDataSource.errorToThrow = Exception('Sign-out failed');
        final result = await repository.signOut();
        expect(result, isA<Error<void>>());
      });
    });

    group('currentUser', () {
      test('returns AuthUser when logged in', () {
        fakeDataSource.fakeUser = testUser;
        expect(repository.currentUser, isNotNull);
        expect(repository.currentUser?.uid, 'test-uid');
      });

      test('returns null when not logged in', () {
        fakeDataSource.fakeUser = null;
        expect(repository.currentUser, isNull);
      });
    });
  });
}
