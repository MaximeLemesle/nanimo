import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

enum NanimoLogoSize { small, large }

/// The Nanimo brand mark.
///
/// There is no logo artwork to ship: the design system defines the mark as the
/// name set in Gluten, so it is drawn as text. It therefore stays crisp at any
/// size and follows the user's text scale, which a bitmap asset would not.
class NanimoLogoWidget extends StatelessWidget {
  final NanimoLogoSize size;
  final bool showTagline;

  const NanimoLogoWidget({
    super.key,
    this.size = NanimoLogoSize.small,
    this.showTagline = false,
  });

  static const String _wordmark = 'nanimo';
  static const String _tagline = 'Chaque moment compte';

  @override
  Widget build(BuildContext context) {
    final wordmarkStyle = switch (size) {
      NanimoLogoSize.small => AppTextStyles.title02,
      NanimoLogoSize.large => AppTextStyles.title01,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_wordmark, style: wordmarkStyle),
        if (showTagline)
          Text(
            _tagline,
            style: AppTextStyles.textLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
