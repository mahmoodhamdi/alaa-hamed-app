import 'package:bloc_test/bloc_test.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
  });

  Widget createTestWidget(AuthState state) {
    whenListen(
      mockAuthCubit,
      Stream<AuthState>.fromIterable([state]),
      initialState: state,
    );

    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
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
                      Text('Error: ${state.message}'),
                      ElevatedButton(
                        onPressed: () => context.read<AuthCubit>().authenticateWithGoogle(),
                        child: const Text(AppStrings.retry),
                      ),
                    ],
                  );
                } else if (state is AuthSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const Text(AppStrings.signedIn),
                    ],
                  );
                }
                return ElevatedButton.icon(
                  onPressed: () => context.read<AuthCubit>().authenticateWithGoogle(),
                  icon: const Icon(Icons.login),
                  label: const Text(AppStrings.signInWithGoogle),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  group('AuthView Widget Tests', () {
    testWidgets('should display sign in button in initial state', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthInitial()));
      expect(find.text(AppStrings.signInWithGoogle), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
    });

    testWidgets('should display app bar with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthInitial()));
      expect(find.text(AppStrings.googleSignIn), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthLoading()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message on failure', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthFailure('Auth failed')));
      expect(find.text('Error: Auth failed'), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display success message on success', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthSuccess('token123456789012345')));
      expect(find.text(AppStrings.signedIn), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should call authenticateWithGoogle when sign in pressed', (tester) async {
      when(() => mockAuthCubit.authenticateWithGoogle()).thenAnswer((_) async {});
      await tester.pumpWidget(createTestWidget(AuthInitial()));
      await tester.tap(find.text(AppStrings.signInWithGoogle));
      await tester.pump();
      verify(() => mockAuthCubit.authenticateWithGoogle()).called(1);
    });

    testWidgets('should call authenticateWithGoogle when retry pressed', (tester) async {
      when(() => mockAuthCubit.authenticateWithGoogle()).thenAnswer((_) async {});
      await tester.pumpWidget(createTestWidget(AuthFailure('Error')));
      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();
      verify(() => mockAuthCubit.authenticateWithGoogle()).called(1);
    });

    testWidgets('should show red error icon on failure', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthFailure('Error')));
      final iconFinder = find.byIcon(Icons.error_outline);
      expect(iconFinder, findsOneWidget);
      final Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });

    testWidgets('should show green success icon on success', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthSuccess('token123456789012345')));
      final iconFinder = find.byIcon(Icons.check_circle);
      expect(iconFinder, findsOneWidget);
      final Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.green);
    });
  });
}
