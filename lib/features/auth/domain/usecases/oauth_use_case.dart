// lib/features/auth/domain/usecases/oauth_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';

class OAuthUseCase {
  final AuthRepository repository;

  OAuthUseCase(this.repository);

  Future<Either<Failure, String>> authenticateWithGoogle() async {
    return await repository.authenticateWithGoogle();
  }
}
