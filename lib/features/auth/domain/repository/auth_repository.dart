// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> authenticateWithGoogle();
}
