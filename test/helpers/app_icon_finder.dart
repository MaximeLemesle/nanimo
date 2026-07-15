import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';

/// Locates an [AppIconWidget] by its Streamline name, the SVG equivalent of
/// `find.byIcon` for Material icons. Pass an [AppIcons] constant:
///
/// ```dart
/// await tester.tap(findAppIcon(AppIcons.petPawSolid));
/// tester.widget<AppIconWidget>(findAppIcon(AppIcons.homeSolid)).color;
/// ```
Finder findAppIcon(String name) => find.byWidgetPredicate(
      (widget) => widget is AppIconWidget && widget.name == name,
      description: 'AppIconWidget("$name")',
    );
