import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

/// Below `app_config.min_supported_version`, the app stops at an update screen.
/// Any failure lets the user in: an outage must never lock the app (NAN-133).
class MinVersionCheck {
  final SupabaseClient _supabase;
  final String currentVersion;

  const MinVersionCheck(this._supabase, {required this.currentVersion});

  /// The store url to update from, or null when the app may run.
  Future<String?> requiredUpdate() async {
    try {
      final rows = await _supabase
          .from('app_config')
          .select('key, value')
          .inFilter('key', ['min_supported_version', _storeKey]);
      final config = {for (final row in rows) row['key'] as String: row['value'] as String};
      final minimum = config['min_supported_version'];
      if (minimum == null || compareVersions(currentVersion, minimum) >= 0) return null;
      return config[_storeKey] ?? '';
    } catch (_) {
      return null;
    }
  }

  static String get _storeKey => Platform.isIOS ? 'store_url_ios' : 'store_url_android';

  /// Numeric compare of `x.y.z`, build suffix ignored.
  static int compareVersions(String a, String b) {
    List<int> parts(String version) =>
        version.split('+').first.split('.').map((part) => int.tryParse(part) ?? 0).toList();
    final left = parts(a);
    final right = parts(b);
    for (var i = 0; i < 3; i++) {
      final l = i < left.length ? left[i] : 0;
      final r = i < right.length ? right[i] : 0;
      if (l != r) return l.compareTo(r);
    }
    return 0;
  }
}

class MinVersionGate extends StatefulWidget {
  final Future<String?> Function() requiredUpdate;
  final Widget child;

  const MinVersionGate({super.key, required this.requiredUpdate, required this.child});

  @override
  State<MinVersionGate> createState() => _MinVersionGateState();
}

class _MinVersionGateState extends State<MinVersionGate> {
  String? _storeUrl;

  @override
  void initState() {
    super.initState();
    widget.requiredUpdate().then((url) {
      if (mounted && url != null) setState(() => _storeUrl = url);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeUrl = _storeUrl;
    if (storeUrl == null) return widget.child;
    return UpdateRequiredScreen(storeUrl: storeUrl);
  }
}

class UpdateRequiredScreen extends StatelessWidget {
  final String storeUrl;

  const UpdateRequiredScreen({super.key, required this.storeUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mets à jour Nanimo', style: AppTextStyles.title01, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Cette version n’est plus prise en charge. La nouvelle garde tous tes souvenirs et le carnet de tes animaux.',
                style: AppTextStyles.text,
                textAlign: TextAlign.center,
              ),
              if (storeUrl.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                ButtonWidget(
                  label: 'Mettre à jour',
                  fullWidth: true,
                  onPressed: () => launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
