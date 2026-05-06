import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';

class ErrorScreen extends StatelessWidget {
  final Exception? error;
  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Page introuvable',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,),
            const SizedBox(height: 8),
            Text(
              "Cette route n'existe pas.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(RouteNames.home),
                child: const Text("Retour à l'accueil"),
              ),
            ),
            TextButton(
              onPressed: () => context.canPop() ? context.pop() : context.go(RouteNames.home),
              child: const Text('Page précédente'),
            ),
          ],
        ),
      ),
    );
  }
}