import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';

/// The 3D diary illustration, with the pet's portrait in the cover's white
/// medallion and its name on the label underneath.
class HealthDiaryBookWidget extends StatelessWidget {
  final PetPortrait? portrait;
  final String petName;

  const HealthDiaryBookWidget(
      {super.key, required this.portrait, required this.petName});

  /// The image is 1278 x 1230 px, shown 280 pt wide.
  static const _width = 280.0;
  static const _height = 269.5;

  /// The cover recedes in perspective: its rows rise to the right near the
  /// top and flatten lower down, while its sides lean left.
  static const _medallionSlope = -0.05;
  static const _labelSlope = 0.06;
  static const _lean = -0.33;

  static const _nameFontSize = 14.0;
  static const _nameWidth = 100.0;

  /// The label's two rules, at the name's centre: their height in the widget
  /// and how far the lower one drifts left with the lean.
  static const _upperRule = 173.0;
  static const _lowerRule = 187.5;
  static const _lowerRuleShift = 5.0;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context)
        .style
        .merge(AppTextStyles.title03.copyWith(fontSize: _nameFontSize));
    final (first, second) =
        _splitName(petName, style, MediaQuery.textScalerOf(context));

    return Semantics(
      label: 'Carnet de santé de $petName',
      child: SizedBox(
        width: _width,
        height: _height,
        child: Stack(children: [
          Positioned.fill(
              child: Image.asset('assets/health_diary/health_book.png',
                  fit: BoxFit.contain)),
          Positioned(
            left: 91,
            top: 47,
            width: 100,
            height: 94,
            child: _onCover(
                _medallionSlope,
                Center(
                  child: portrait == null
                      ? const Icon(Icons.pets_rounded,
                          size: 52, color: AppColors.primary)
                      : PetAvatarWidget(
                          portrait: portrait!, size: PetAvatarSize.medium),
                )),
          ),
          _onRule(_upperRule, 0, first, style),
          if (second != null)
            _onRule(_lowerRule, _lowerRuleShift, second, style),
        ]),
      ),
    );
  }

  /// A line of the name written on a rule of the label, baseline on the rule.
  Widget _onRule(double rule, double shift, String text, TextStyle style) {
    const ascent = 20.0;
    return Positioned(
      left: 67 - shift,
      top: rule - ascent,
      width: _nameWidth,
      height: ascent + 8,
      child: _onCover(
          _labelSlope,
          Align(
            alignment: Alignment.topCenter,
            child: Baseline(
              baseline: ascent,
              baselineType: TextBaseline.alphabetic,
              child: _BoldText(text, style),
            ),
          )),
    );
  }

  /// One line if the name fits, else two cut at a space or after a hyphen,
  /// with as much as fits on the first. A first word too long for the line is
  /// hyphenated. What still overflows ends in "…".
  static (String, String?) _splitName(
      String name, TextStyle style, TextScaler scaler) {
    bool fits(String text) =>
        (TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textScaler: scaler,
          textDirection: TextDirection.ltr,
        )..layout())
            .width <=
        _nameWidth;

    if (fits(name)) return (name, null);
    for (var i = name.length - 1; i > 0; i--) {
      final (first, second) = switch (name[i]) {
        '-' => (name.substring(0, i + 1), name.substring(i + 1)),
        ' ' => (name.substring(0, i), name.substring(i + 1)),
        _ => ('', ''),
      };
      if (first.trim().isNotEmpty &&
          second.trim().isNotEmpty &&
          fits(first.trim())) {
        return (first.trim(), second.trim());
      }
    }
    for (var i = name.length - 1; i > 1; i--) {
      final first = '${name.substring(0, i).trimRight()}-';
      if (fits(first)) return (first, name.substring(i).trim());
    }
    return (name, null);
  }

  Widget _onCover(double slope, Widget child) => Transform(
        transform: Matrix4.identity()
          ..setEntry(1, 0, slope)
          ..setEntry(0, 1, _lean),
        alignment: Alignment.center,
        child: child,
      );
}

/// Comfortaa ships in bold only, so a thin outline of the same colour
/// thickens it a notch.
class _BoldText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _BoldText(this.text, this.style);

  static const _stroke = 0.7;

  @override
  Widget build(BuildContext context) {
    Text line(TextStyle style) => Text(text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: style);

    return Stack(children: [
      line(style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = _stroke
            ..strokeJoin = StrokeJoin.round
            ..color = style.color ?? AppColors.textPrimary,
          color: null)),
      line(style),
    ]);
  }
}
