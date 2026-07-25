import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/nanimo_logo_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsFooterWidget extends StatefulWidget {
  const SettingsFooterWidget({super.key});

  @override
  State<SettingsFooterWidget> createState() => SettingsFooterWidgetState();
}

class SettingsFooterWidgetState extends State<SettingsFooterWidget> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = info.version);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NanimoLogoWidget(showTagline: true),
        const SizedBox(height: AppSpacing.md),
        Text(
          _version == null ? 'Version —' : 'Version $_version',
          style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
