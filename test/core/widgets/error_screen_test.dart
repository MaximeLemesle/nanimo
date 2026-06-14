import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/widgets/error_screen.dart';

void main() {
  // A minimal router so the action buttons have a GoRouter in their context.
  GoRouter buildRouter() => GoRouter(
        initialLocation: '/error',
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const Scaffold(body: Text('home')),
          ),
          GoRoute(
            path: '/error',
            builder: (context, state) => const ErrorScreen(),
          ),
        ],
      );

  testWidgets('renders the not-found message and actions', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
    await tester.pumpAndSettle();

    expect(find.text('Page introuvable'), findsOneWidget);
    expect(find.text("Cette route n'existe pas."), findsOneWidget);
    expect(find.text("Retour à l'accueil"), findsOneWidget);
    expect(find.text('Page précédente'), findsOneWidget);
  });

  testWidgets('navigates home when tapping the primary button',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Retour à l'accueil"));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('falls back home when tapping previous with nothing to pop',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Page précédente'));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });
}
