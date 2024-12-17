// lib/features/auth/presentation/screens/auth_screen.dart
import 'package:eng_alaa_hammed/core/depandancy_injection/service_locator.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Google Sign In')),
        body: Center(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return CircularProgressIndicator();
              } else if (state is AuthFailure) {
                return Text('Error: ${state.message}');
              } else if (state is AuthSuccess) {
                return Text('Signed in! Access Token: ${state.accessToken}');
              }
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().authenticateWithGoogle();
                },
                child: Text('Sign In with Google'),
              );
            },
          ),
        ),
      ),
    );
  }
}
