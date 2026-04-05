import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Firebase Authentication implementation of [AuthDataSourcePort].
///
/// Satisfies Golden Rule 4: API Layer Must Be Replaceable.
/// This is a **driven adapter** in hexagonal terminology.
///
/// To swap to Supabase or another provider, create a new adapter
/// implementing [AuthDataSourcePort] and update the DI registration
/// — **zero changes** to domain, use cases, or presentation.
@LazySingleton(as: AuthDataSourcePort)
class AuthFirebaseAdapter implements AuthDataSourcePort {
  final fb.FirebaseAuth _firebaseAuth;
  final gsi.GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  AuthFirebaseAdapter(this._firebaseAuth, this._googleSignIn);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.trace(
        'Firebase signIn attempt for: $email',
        tag: AppLogTags.authCubit,
      );

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'Sign-in returned null user.');
      }

      AppLogger.info(
        'Firebase signIn succeeded: ${user.uid}',
        tag: AppLogTags.authCubit,
      );

      return _mapFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      AppLogger.error(
        'Firebase signIn error: ${e.code}',
        tag: AppLogTags.authCubit,
        error: e,
      );
      throw ServerException(message: _mapFirebaseError(e.code));
    }
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.trace(
        'Firebase signUp attempt for: $email',
        tag: AppLogTags.authCubit,
      );

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'Sign-up returned null user.');
      }

      // Update display name after account creation.
      await user.updateDisplayName(name);
      // Reload to pick up the display name change.
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser!;

      AppLogger.info(
        'Firebase signUp succeeded: ${updatedUser.uid}',
        tag: AppLogTags.authCubit,
      );

      return _mapFirebaseUser(updatedUser);
    } on fb.FirebaseAuthException catch (e) {
      AppLogger.error(
        'Firebase signUp error: ${e.code}',
        tag: AppLogTags.authCubit,
        error: e,
      );
      throw ServerException(message: _mapFirebaseError(e.code));
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      AppLogger.trace(
        'Google sign-in flow started',
        tag: AppLogTags.authCubit,
      );

      // Initialize the GoogleSignIn instance if not already done.
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize();
        _googleSignInInitialized = true;
      }

      // Trigger the interactive native Google Sign-In flow.
      final googleAccount = await _googleSignIn.authenticate();
      
      // Obtain the auth details from the authenticated Google account.
      final googleAuth = googleAccount.authentication;

      // Create a Firebase credential from the Google ID token.
      final credential = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential.
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException(
          message: 'Google sign-in returned null user.',
        );
      }

      AppLogger.info(
        'Google sign-in succeeded: ${user.uid}',
        tag: AppLogTags.authCubit,
      );

      return _mapFirebaseUser(user);
    } on ServerException {
      rethrow;
    } on fb.FirebaseAuthException catch (e) {
      AppLogger.error(
        'Firebase Google sign-in error: ${e.code}',
        tag: AppLogTags.authCubit,
        error: e,
      );
      throw ServerException(message: _mapFirebaseError(e.code));
    } on gsi.GoogleSignInException catch (e) {
      if (e.code == gsi.GoogleSignInExceptionCode.canceled) {
         throw const ServerException(message: 'Google sign-in was cancelled.');
      }
      AppLogger.error(
        'Google sign-in exception: ${e.code}',
        tag: AppLogTags.authCubit,
        error: e,
      );
      throw const ServerException(
        message: 'Google sign-in failed. Please try again.',
      );
    } on Exception catch (e) {
      AppLogger.error(
        'Google sign-in unexpected error',
        tag: AppLogTags.authCubit,
        error: e,
      );
      throw ServerException(
        message: 'Google sign-in failed. Please try again.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    AppLogger.info('Firebase signOut', tag: AppLogTags.authCubit);
    // Sign out from Google to allow account selection on next login.
    try {
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize();
        _googleSignInInitialized = true;
      }
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore Google sign-out failures
    }
    await _firebaseAuth.signOut();
  }

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapFirebaseUser(user) : null;
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
      (user) => user != null ? _mapFirebaseUser(user) : null,
    );
  }

  // ── Private helpers ──────────────────────────────────────────────

  /// Maps a Firebase [User] to our domain [AuthUser] entity.
  AuthUser _mapFirebaseUser(fb.User user) {
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  /// Maps Firebase error codes to human-readable messages.
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
