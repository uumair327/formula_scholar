import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:injectable/injectable.dart';

/// Injectable module providing Firebase service instances.
///
/// External dependencies (e.g. Firebase SDK singletons) that cannot
/// be annotated with `@injectable` directly are exposed here via
/// `@module` factory methods.
///
/// To swap to Supabase, you would add a `SupabaseModule` and update
/// the adapter registration — the rest of the app stays unchanged.
@module
abstract class FirebaseModule {
  /// Provides the global [FirebaseAuth] instance to the DI container.
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  /// Provides the global [FirebaseFirestore] instance.
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Provides the [gsi.GoogleSignIn] singleton instance.
  @lazySingleton
  gsi.GoogleSignIn get googleSignIn => gsi.GoogleSignIn.instance;
}
