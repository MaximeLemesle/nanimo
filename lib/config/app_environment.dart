/// Which Supabase project the build talks to (NAN-063). Picked at build time
/// with `--dart-define=ENV=dev`; anything else, or nothing, is production.
enum AppEnvironment {
  dev,
  prod;

  static const _defined = String.fromEnvironment('ENV');

  static AppEnvironment get current => parse(_defined);

  static AppEnvironment parse(String value) => value.trim().toLowerCase() == 'dev' ? dev : prod;

  bool get isDev => this == dev;

  /// Production keeps the historical `.env`, which the release workflow writes.
  String get dotenvFile => isDev ? 'env/dev.env' : '.env';

  /// Name sent to Sentry and PostHog, so dev noise never mixes with prod.
  String get reportingName => isDev ? 'development' : 'production';
}
