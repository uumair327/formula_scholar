import '../entities/auth_user.dart';

/// Port interface for remote authentication operations.
///
/// This is the **driven port** (secondary port) in hexagonal terminology.
/// The domain layer owns this interface; infrastructure adapters implement it.
///
/// Implementations:
/// - [AuthFirebaseAdapter] — Firebase Authentication
/// - (future) `AuthSupabaseAdapter` — Supabase Auth
/// - (future) `AuthRemoteAdapter` — Custom REST API
///
/// To swap providers, create a new adapter and update the DI registration
/// — **zero changes** to domain, use cases, or presentation.
abstract interface class AuthDataSourcePort {
  /// Signs in with [email] and [password], returning the authenticated user.
  Future<AuthUser> signIn({required String email, required String password});

  /// Creates a new account with [name], [email], and [password].
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Signs in using Google OAuth credentials.
  ///
  /// Triggers the native Google Sign-In flow and authenticates
  /// the resulting credential with the auth provider.
  Future<AuthUser> signInWithGoogle();

  /// Signs the current user out.
  Future<void> signOut();

  /// Deletes the current user's account permanently.
  Future<void> deleteAccount();

  /// Sends a password reset email to the given [email].
  Future<void> sendPasswordResetEmail({required String email});

  /// Returns the currently signed-in user, or `null` if unauthenticated.
  AuthUser? get currentUser;

  /// A stream that emits an [AuthUser] whenever the auth state changes.
  ///
  /// Emits `null` when the user signs out.
  Stream<AuthUser?> authStateChanges();
}
