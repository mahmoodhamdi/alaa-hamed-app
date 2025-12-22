import 'package:eng_alaa_hammed/features/auth/domain/usecases/check_auth_use_case.dart';
import 'package:eng_alaa_hammed/features/splash/logic/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthUseCase checkAuthUseCase;

  SplashCubit(this.checkAuthUseCase) : super(const SplashInitial());

  Future<void> checkAuthStatus() async {
    emit(const SplashLoading());

    final result = await checkAuthUseCase.call();

    result.fold(
      (failure) => emit(const SplashUnauthenticated()),
      (token) => emit(SplashAuthenticated(token)),
    );
  }
}
