import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/core/services/secure_storage_service.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final OAuthUseCase oAuthUseCase;
  final SecureStorageService secureStorageService;

  AuthCubit({
    required this.oAuthUseCase,
    required this.secureStorageService,
  }) : super(AuthInitial());

  /// Check if user is already authenticated (has stored token)
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    LoggerHelper.debug('Checking authentication status...');

    try {
      final hasToken = await secureStorageService.hasAccessToken();
      if (hasToken) {
        final token = await secureStorageService.getAccessToken();
        LoggerHelper.info('User is already authenticated');
        emit(AuthSuccess(token!));
      } else {
        LoggerHelper.info('No stored token found, user needs to authenticate');
        emit(AuthInitial());
      }
    } catch (e) {
      LoggerHelper.error('Error checking auth status: $e');
      emit(AuthInitial());
    }
  }

  Future<void> authenticateWithGoogle() async {
    emit(AuthLoading());
    LoggerHelper.debug('Starting authentication process...');

    final result = await oAuthUseCase(param: const NoParams());

    result.fold(
      (failure) {
        LoggerHelper.error('Authentication failed: ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (accessToken) async {
        LoggerHelper.info('Authentication successful, saving token securely');
        // Save token securely
        await secureStorageService.saveAccessToken(accessToken);
        LoggerHelper.info('Token saved securely');
        emit(AuthSuccess(accessToken));
      },
    );
  }

  /// Logout and clear stored credentials
  Future<void> logout() async {
    LoggerHelper.debug('Logging out...');
    try {
      await secureStorageService.clearAll();
      LoggerHelper.info('All credentials cleared');
      emit(AuthInitial());
    } catch (e) {
      LoggerHelper.error('Error during logout: $e');
      emit(AuthInitial());
    }
  }
}
