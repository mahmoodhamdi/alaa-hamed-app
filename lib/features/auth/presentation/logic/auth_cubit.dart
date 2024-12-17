// lib/features/auth/presentation/logic/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final OAuthUseCase oAuthUseCase;

  AuthCubit(this.oAuthUseCase) : super(AuthInitial());

  Future<void> authenticateWithGoogle() async {
    emit(AuthLoading());
    LoggerHelper.debug('Starting authentication process...');

    final result = await oAuthUseCase.authenticateWithGoogle();

    result.fold(
      (failure) {
        LoggerHelper.error('Authentication failed: ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (accessToken) {
        LoggerHelper.info('Authentication successful, received access token');
        emit(AuthSuccess(accessToken));
      },
    );
  }
}
