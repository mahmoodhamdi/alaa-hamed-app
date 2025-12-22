import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashAuthenticated extends SplashState {
  final String token;

  const SplashAuthenticated(this.token);

  @override
  List<Object?> get props => [token];
}

class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}
