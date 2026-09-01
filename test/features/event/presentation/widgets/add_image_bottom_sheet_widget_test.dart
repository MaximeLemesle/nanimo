import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/add_image_bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

/// Hands back a fixed set of files, whatever the source.
class _FakeImagePicker extends ImagePickerPlatform {
  _FakeImagePicker(this._paths);
  final List<String> _paths;

  @override
  Future<List<XFile>> getMultiImageWithOptions({
    MultiImagePickerOptions options = const MultiImagePickerOptions(),
  }) async =>
      _paths.map(XFile.new).toList();

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async =>
      _paths.isEmpty ? null : XFile(_paths.first);
}

SubscriptionState _plan(String planName) =>
    SubscriptionState.loaded(SubscriptionConfigModel(
      configId: 'cfg',
      planName: planName,
      maxImagesPerEvent: planName == 'premium' ? 5 : 1,
      maxPets: 1,
    ));

void main() {
  late List<XFile>? result;

  /// Behind a router: the locked row is a shortcut to /paywall.
  Future<void> pumpSheet(
    WidgetTester tester,
    SubscriptionState subscription,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    result = null;
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await AddImageBottomSheetWidget.show(
                    context,
                    subscription: subscription,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.paywall,
          builder: (_, __) => const Scaffold(body: Text('paywall-stub')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Color labelColorOf(WidgetTester tester, String label) =>
      tester.widget<Text>(find.text(label)).style!.color!;

  testWidgets('renders the three photo sources', (tester) async {
    await pumpSheet(tester, _plan('premium'));

    expect(find.text('Que voulez-vous faire ?'), findsOneWidget);
    expect(find.text('Prendre une photo'), findsOneWidget);
    expect(find.text('Sélectionner une photo'), findsOneWidget);
    expect(find.text(multipleImagesLabel), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byIcon(Icons.collections_outlined), findsOneWidget);
  });

  testWidgets('premium leaves the multi pick active', (tester) async {
    ImagePickerPlatform.instance =
        _FakeImagePicker(['/tmp/a.jpg', '/tmp/b.jpg']);

    await pumpSheet(tester, _plan('premium'));

    expect(find.byIcon(Icons.lock_outline), findsNothing);
    expect(find.text('Premium'), findsNothing);

    await tester.tap(find.text(multipleImagesLabel));
    await tester.pumpAndSettle();

    expect([for (final file in result!) file.path], ['/tmp/a.jpg', '/tmp/b.jpg']);
  });

  testWidgets('the free plan shows the multi pick as deliberately locked',
      (tester) async {
    await pumpSheet(tester, _plan('freemium'));

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(
      labelColorOf(tester, multipleImagesLabel),
      AppColors.textSecondary,
    );
    expect(
      labelColorOf(tester, 'Sélectionner une photo'),
      AppColors.textPrimary,
    );
  });

  testWidgets('tapping the locked row closes the sheet and opens the paywall',
      (tester) async {
    await pumpSheet(tester, _plan('freemium'));

    await tester.tap(find.text(multipleImagesLabel));
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsOneWidget);
    expect(find.text('Que voulez-vous faire ?'), findsNothing);
    expect(result, isNull);
  });

  testWidgets('the single sources stay active on the free plan', (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/a.jpg']);

    await pumpSheet(tester, _plan('freemium'));

    await tester.tap(find.text('Prendre une photo'));
    await tester.pumpAndSettle();

    expect([for (final file in result!) file.path], ['/tmp/a.jpg']);
    expect(find.text('paywall-stub'), findsNothing);
  });

  testWidgets('an unknown plan locks the row without opening the paywall',
      (tester) async {
    await pumpSheet(tester, const SubscriptionState.unknown());

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    await tester.tap(find.text(multipleImagesLabel));
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsNothing);
    expect(find.text(subscriptionUnavailableMessage), findsOneWidget);
  });
}
