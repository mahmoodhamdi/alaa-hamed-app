// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> authenticateWithGoogle();

  /// Attempts to sign in silently using cached credentials.
  /// Returns Right(token) if successful, Left(failure) if no cached session.
  Future<Either<Failure, String>> trySignInSilently();

  /// Checks if a user is currently signed in.
  Future<bool> isSignedIn();

  /// Signs out the current user.
  Future<Either<Failure, void>> signOut();
}
