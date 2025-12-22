import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AuthView handles Google OAuth authentication.
/// Uses StatefulWidget to properly manage BlocProvider lifecycle.
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.googleSignIn)),
        body: Center(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator();
              } else if (state is AuthFailure) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      '${AppStrings.error}: ${state.message}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().authenticateWithGoogle();
                      },
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                );
              } else if (state is AuthSuccess) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.signedIn,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppStrings.accessToken}: ${state.accessToken.substring(0, 20)}...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              }
              return ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthCubit>().authenticateWithGoogle();
                },
                icon: const Icon(Icons.login),
                label: const Text(AppStrings.signInWithGoogle),
              );
            },
          ),
        ),
      ),
    );
  }
}
