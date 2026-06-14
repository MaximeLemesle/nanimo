import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/home/presentation/page/profile_page.dart';

class _MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  testWidgets('logout button calls AuthCubit.logout', (tester) async {
    final authCubit = _MockAuthCubit();
    when(() => authCubit.state).thenReturn(const AuthState.authenticated());
    when(() => authCubit.stream)
        .thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => authCubit.logout()).thenAnswer((_) async {});
    when(() => authCubit.close()).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const ProfilePage(),
        ),
      ),
    );

    expect(find.text('Se déconnecter'), findsOneWidget);

    await tester.tap(find.text('Se déconnecter'));
    await tester.pump();

    verify(() => authCubit.logout()).called(1);
  });
}
