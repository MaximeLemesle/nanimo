import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/app_environment.dart';
import 'package:nanimo/core/widgets/environment_banner.dart';

void main() {
  test('production needs the exact prod define', () {
    expect(AppEnvironment.parse('prod'), AppEnvironment.prod);
    expect(AppEnvironment.parse('dev'), AppEnvironment.dev);
    expect(AppEnvironment.parse(''), AppEnvironment.dev);
  });

  test('an unknown define fails instead of picking an environment', () {
    for (final value in ['staging', 'PROD', ' prod ']) {
      expect(() => AppEnvironment.parse(value), throwsArgumentError);
    }
  });

  test('a build without define stays on dev', () {
    expect(AppEnvironment.current, AppEnvironment.dev);
    expect(AppEnvironment.current.dotenvFile, 'env/dev.env');
    expect(AppEnvironment.compiledMarker, 'nanimo-env-dev');
  });

  test('a missing dev config says how to fix it', () {
    expect(AppEnvironment.dev.missingConfigMessage, contains('env/dev.env.example'));
    expect(AppEnvironment.dev.missingConfigMessage, contains('--dart-define=ENV=prod'));
    expect(AppEnvironment.prod.missingConfigMessage, contains('.env'));
  });

  test('each environment reads its own file and reports its own name', () {
    expect(AppEnvironment.dev.dotenvFile, 'env/dev.env');
    expect(AppEnvironment.dev.reportingName, 'development');
    expect(AppEnvironment.prod.reportingName, 'production');
  });

  testWidgets('the DEV banner shows on dev builds only', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnvironmentBanner(environment: AppEnvironment.dev, child: SizedBox()),
    ));
    expect(find.byType(Banner), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnvironmentBanner(environment: AppEnvironment.prod, child: SizedBox()),
    ));
    expect(find.byType(Banner), findsNothing);
  });
}
