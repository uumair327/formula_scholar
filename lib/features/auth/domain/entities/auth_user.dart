import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
///
/// Pure Dart — no Firebase, Supabase, or provider-specific imports.
/// This is the canonical user representation that flows through
/// ports, use cases, and cubits.
class AuthUser extends Equatable {

  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
  });
  /// Unique identifier assigned by the auth provider.
  final String uid;

  /// User email address.
  final String? email;

  /// User display name.
  final String? displayName;

  /// URL to the user's profile photo.
  final String? photoUrl;

  /// Whether the email has been verified.
  final bool emailVerified;

  /// Sentinel value representing "no user signed in".
  static const AuthUser empty = AuthUser(uid: '');

  /// Whether this user is the empty sentinel.
  bool get isEmpty => uid.isEmpty;

  /// Whether this user represents a real signed-in user.
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, emailVerified];
}
