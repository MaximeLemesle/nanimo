/// Which Supabase project the build talks to (NAN-063). Dev unless built with
/// `--dart-define=ENV=prod`, so a forgotten flag can never reach production (NAN-134).
enum AppEnvironment {
  dev,
  prod;

  static const _defined = String.fromEnvironment('ENV');

  /// Only the selected string is compiled in: `scripts/check_binary_env.sh`
  /// greps it out of a built binary.
  static const compiledMarker = _defined == 'prod' ? 'nanimo-env-prod' : 'nanimo-env-dev';

  static AppEnvironment get current => parse(_defined);

  static AppEnvironment parse(String value) => switch (value) {
        '' || 'dev' => dev,
        'prod' => prod,
        _ => throw ArgumentError.value(value, 'ENV', 'Expected dev or prod'),
      };

  bool get isDev => this == dev;

  /// Production keeps the historical `.env`, which the release workflow writes.
  String get dotenvFile => isDev ? 'env/dev.env' : '.env';

  /// Name sent to Sentry and PostHog, so dev noise never mixes with prod.
  String get reportingName => isDev ? 'development' : 'production';

  String get missingConfigMessage => isDev
      ? 'Missing env/dev.env. Builds target dev by default: copy env/dev.env.example '
          'and fill it in, or build with --dart-define=ENV=prod for production.'
      : 'Missing .env: production builds need it, see .env.example.';
}
