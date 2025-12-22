import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';

class CheckAuthUseCase implements UseCase<Either<Failure, String>, NoParams> {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call({NoParams? param}) async {
    return await repository.trySignInSilently();
  }
}
