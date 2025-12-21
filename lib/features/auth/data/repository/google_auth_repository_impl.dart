import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn googleSignIn;

  GoogleAuthRepositoryImpl(this.googleSignIn);

  @override
  Future<Either<Failure, String>> authenticateWithGoogle() async {
    try {
      LoggerHelper.debug('Attempting Google sign-in...');

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        LoggerHelper.error('Google sign-in failed: User canceled the login');
        return const Left(AuthenticationFailure('User canceled sign-in'));
      }

      LoggerHelper.info(
          'Google sign-in successful, retrieving authentication token...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final accessToken = googleAuth.accessToken;
      if (accessToken != null) {
        LoggerHelper.info('Successfully retrieved access token');
        return Right(accessToken);
      } else {
        LoggerHelper.error('Google authentication token is null');
        return const Left(AuthenticationFailure('Failed to get access token'));
      }
    } catch (e) {
      LoggerHelper.error('An error occurred during Google authentication: $e');
      return Left(AuthenticationFailure('Authentication error: $e'));
    }
  }
}
