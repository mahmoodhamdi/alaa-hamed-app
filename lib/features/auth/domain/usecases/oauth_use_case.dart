import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';

class OAuthUseCase implements UseCase<Either<Failure, String>, NoParams> {
  final AuthRepository repository;

  OAuthUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call({NoParams? param}) {
    return repository.authenticateWithGoogle();
  }
}
