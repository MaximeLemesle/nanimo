import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/app_environment.dart';
import 'package:nanimo/core/widgets/environment_banner.dart';

void main() {
  test('only an explicit dev define selects the dev environment', () {
    expect(AppEnvironment.parse('dev'), AppEnvironment.dev);
    expect(AppEnvironment.parse(' DEV '), AppEnvironment.dev);
    expect(AppEnvironment.parse(''), AppEnvironment.prod);
    expect(AppEnvironment.parse('staging'), AppEnvironment.prod);
  });

  test('a build without define stays on production', () {
    expect(AppEnvironment.current, AppEnvironment.prod);
    expect(AppEnvironment.current.dotenvFile, '.env');
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
