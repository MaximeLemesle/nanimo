import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/version/min_version_gate.dart';

import '../../helpers/supabase_mocks.dart';

void main() {
  setUpAll(registerSupabaseFallbacks);

  group('compareVersions', () {
    test('compares numerically, ignoring the build number', () {
      expect(MinVersionCheck.compareVersions('1.3.0', '1.3.0'), 0);
      expect(MinVersionCheck.compareVersions('1.10.0', '1.9.9'), greaterThan(0));
      expect(MinVersionCheck.compareVersions('1.2.2+10', '1.3.0'), lessThan(0));
      expect(MinVersionCheck.compareVersions('2', '1.9'), greaterThan(0));
      expect(MinVersionCheck.compareVersions('1.3', '1.3.0'), 0);
    });
  });

  group('requiredUpdate', () {
    test('a version at or above the minimum runs', () async {
      final supabase = MockSupabaseClient();
      stubSelect(supabase, 'app_config', resolver: () => [
            {'key': 'min_supported_version', 'value': '1.3.0'},
          ]);

      expect(await MinVersionCheck(supabase, currentVersion: '1.3.0').requiredUpdate(), isNull);
    });

    test('an older version is sent to the store, even without a link yet', () async {
      final supabase = MockSupabaseClient();
      stubSelect(supabase, 'app_config', resolver: () => [
            {'key': 'min_supported_version', 'value': '1.3.0'},
          ]);

      expect(await MinVersionCheck(supabase, currentVersion: '1.2.2').requiredUpdate(), '');
    });

    test('a failure lets the user in', () async {
      final supabase = MockSupabaseClient();
      stubSelect(supabase, 'app_config', resolver: () => throw Exception('offline'));

      expect(await MinVersionCheck(supabase, currentVersion: '1.0.0').requiredUpdate(), isNull);
    });
  });

  group('MinVersionGate', () {
    testWidgets('shows the app while nothing is required', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MinVersionGate(requiredUpdate: () async => null, child: const Text('app')),
      ));
      await tester.pumpAndSettle();

      expect(find.text('app'), findsOneWidget);
    });

    testWidgets('stops at the update screen when required', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MinVersionGate(requiredUpdate: () async => 'https://store', child: const Text('app')),
      ));
      await tester.pumpAndSettle();

      expect(find.text('app'), findsNothing);
      expect(find.text('Mets à jour Nanimo'), findsOneWidget);
      expect(find.text('Mettre à jour'), findsOneWidget);
    });

    testWidgets('without a store link the screen has no button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: UpdateRequiredScreen(storeUrl: '')));

      expect(find.text('Mettre à jour'), findsNothing);
    });
  });
}
