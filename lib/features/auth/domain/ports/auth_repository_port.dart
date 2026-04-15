import '../../../../core/error/result.dart';
import '../entities/auth_user.dart';

/// Domain layer interface for authentication.
///
/// This is the **primary port** in hexagonal terminology — the interface
/// that the application layer (use cases) depends on.
///
/// Satisfies Golden Rule 2: SOLID (Dependency Inversion)
/// The presentation layer depends on this abstraction via use cases,
/// not a concrete implementation.
///
/// Returns [Result] to enforce typed error handling at the boundary.
abstract interface class AuthRepositoryPort {
  /// Signs in a user with [email] and [password].
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  });

  /// Signs up a new user with [name], [email], and [password].
  Future<Result<AuthUser>> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Signs in using Google OAuth.
  ///
  /// Returns [Result] wrapping [AuthUser] on success, or a typed
  /// [Failure] on cancellation/error.
  Future<Result<AuthUser>> signInWithGoogle();

  /// Signs the current user out.
  Future<Result<void>> signOut();

  /// Deletes the current user's account permanently.
  Future<Result<void>> deleteAccount();

  /// Sends a password reset email to the given [email].
  Future<Result<void>> sendPasswordResetEmail({required String email});

  /// Returns the currently signed-in user, or `null`.
  AuthUser? get currentUser;

  /// Stream of auth state changes for reactive auth guards.
  Stream<AuthUser?> authStateChanges();
}
