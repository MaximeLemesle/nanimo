import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/event_photo/event_photo_picker_widget.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit(int maxImagesPerEvent, {String planName = 'freemium'})
      : super(SubscriptionState.loaded(SubscriptionConfigModel(
          configId: 'cfg',
          planName: planName,
          maxImagesPerEvent: maxImagesPerEvent,
          maxPets: 1,
        )));

  _FakeSubscriptionCubit.unloaded() : super(const SubscriptionState.unknown());

  @override
  void noSuchMethod(Invocation invocation) {}
}

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

void main() {
  /// Paths of the local photos currently held, in collage order.
  List<String> pathsOf(List<CollageImage> images) => [
        for (final image in images)
          if (image is LocalCollageImage) image.file.path,
      ];

  /// Hosts the picker with the page's own list, so a change comes back through
  /// onChanged exactly as the create and edit pages wire it.
  Future<List<CollageImage>> pumpPicker(
    WidgetTester tester, {
    required List<CollageImage> initial,
    int maxImagesPerEvent = 5,
    String planName = 'freemium',
    bool subscriptionLoaded = true,
    void Function(RemoteCollageImage)? onRemoteImageRemoved,
    Future<String> Function(String assetPath)? urlResolver,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final images = List.of(initial);
    final subscription = subscriptionLoaded
        ? _FakeSubscriptionCubit(maxImagesPerEvent, planName: planName)
        : _FakeSubscriptionCubit.unloaded();
    addTearDown(subscription.close);

    /// Behind a router: the quota snack bar carries a shortcut to /paywall.
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => EventPhotoPickerWidget(
                images: images,
                urlResolver: urlResolver,
                onChanged: (next) => setState(() {
                  images
                    ..clear()
                    ..addAll(next);
                }),
                onRemoteImageRemoved: onRemoteImageRemoved,
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

    await tester.pumpWidget(
      BlocProvider<SubscriptionCubit>.value(
        value: subscription,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return images;
  }

  Future<void> openGridTile(WidgetTester tester, int index) async {
    await tester.tap(find.byType(PolaroidCollageWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('event-image-grid-tile-$index')));
    await tester.pumpAndSettle();
  }

  testWidgets('goes straight to the picker while no photo is held',
      (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/a.jpg']);

    final images = await pumpPicker(tester, initial: const []);

    await tester.tap(find.byType(PolaroidCollageWidget));
    await tester.pumpAndSettle();

    expect(find.text('Photos du souvenir'), findsNothing);
    await tester.tap(find.text('Sélectionner plusieurs photos'));
    await tester.pumpAndSettle();

    expect(pathsOf(images), ['/tmp/a.jpg']);
  });

  /// The point of NAN-056: the photo is swapped where it sits instead of being
  /// deleted and appended at the end of the collage.
  testWidgets('replaces the tapped photo in place', (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/new.jpg']);

    final images = await pumpPicker(
      tester,
      initial: [
        LocalCollageImage(XFile('/tmp/a.jpg')),
        LocalCollageImage(XFile('/tmp/b.jpg')),
        LocalCollageImage(XFile('/tmp/c.jpg')),
      ],
    );

    await openGridTile(tester, 1);
    expect(find.text('Modifier la photo'), findsOneWidget);

    await tester.tap(find.text('Sélectionner une photo'));
    await tester.pumpAndSettle();

    expect(pathsOf(images), ['/tmp/a.jpg', '/tmp/new.jpg', '/tmp/c.jpg']);
  });

  testWidgets('replacing keeps the photo count, so the quota still holds',
      (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/new.jpg']);

    final images = await pumpPicker(
      tester,
      initial: [LocalCollageImage(XFile('/tmp/a.jpg'))],
      maxImagesPerEvent: 1,
    );

    await openGridTile(tester, 0);
    await tester.tap(find.text('Sélectionner une photo'));
    await tester.pumpAndSettle();

    expect(pathsOf(images), ['/tmp/new.jpg']);
  });

  testWidgets('drops the tapped photo on delete', (tester) async {
    final images = await pumpPicker(
      tester,
      initial: [
        LocalCollageImage(XFile('/tmp/a.jpg')),
        LocalCollageImage(XFile('/tmp/b.jpg')),
      ],
    );

    await openGridTile(tester, 0);
    await tester.tap(find.text('Supprimer la photo'));
    await tester.pumpAndSettle();

    expect(pathsOf(images), ['/tmp/b.jpg']);
  });

  testWidgets('reports a stored photo leaving the selection', (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/new.jpg']);
    const stored = RemoteCollageImage(eventImageId: 'i1', assetPath: 'u/e/1.jpg');
    final removed = <RemoteCollageImage>[];

    await pumpPicker(
      tester,
      initial: const [stored],
      onRemoteImageRemoved: removed.add,
      urlResolver: (path) async => 'https://example.com/$path',
    );

    await openGridTile(tester, 0);
    await tester.tap(find.text('Sélectionner une photo'));
    await tester.pumpAndSettle();

    expect(removed, [stored]);
  });

  /// Walks the add flow to its refusal, which is where the quota message and
  /// its upsell surface.
  Future<void> addPastTheQuota(WidgetTester tester) async {
    await tester.tap(find.byType(PolaroidCollageWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('event-image-grid-add-tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sélectionner plusieurs photos'));
    await tester.pumpAndSettle();
  }

  testWidgets('refuses to add past the plan quota', (tester) async {
    ImagePickerPlatform.instance =
        _FakeImagePicker(['/tmp/b.jpg', '/tmp/c.jpg']);

    final images = await pumpPicker(
      tester,
      initial: [LocalCollageImage(XFile('/tmp/a.jpg'))],
      maxImagesPerEvent: 1,
    );

    await addPastTheQuota(tester);

    expect(pathsOf(images), ['/tmp/a.jpg']);
    expect(find.textContaining('limité à 1 photo'), findsOneWidget);
  });

  /// NAN-059: the free user hits the cap and the paywall is one tap away.
  testWidgets('offers the paywall when the free photo quota blocks',
      (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/b.jpg']);

    await pumpPicker(
      tester,
      initial: [LocalCollageImage(XFile('/tmp/a.jpg'))],
      maxImagesPerEvent: 1,
    );

    await addPastTheQuota(tester);
    expect(find.widgetWithText(SnackBarAction, 'Passer premium'), findsOneWidget);

    await tester.tap(find.text('Passer premium'));
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsOneWidget);
  });

  testWidgets('a premium user gets the premium cap and no upsell',
      (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/f.jpg']);

    await pumpPicker(
      tester,
      initial: [
        LocalCollageImage(XFile('/tmp/a.jpg')),
        LocalCollageImage(XFile('/tmp/b.jpg')),
        LocalCollageImage(XFile('/tmp/c.jpg')),
        LocalCollageImage(XFile('/tmp/d.jpg')),
        LocalCollageImage(XFile('/tmp/e.jpg')),
      ],
      maxImagesPerEvent: 5,
      planName: 'premium',
    );

    await addPastTheQuota(tester);

    expect(find.textContaining('Limite de 5 photos'), findsOneWidget);
    expect(find.text('Passer premium'), findsNothing);
  });

  testWidgets('keeps the degraded message when the plan is unknown',
      (tester) async {
    ImagePickerPlatform.instance = _FakeImagePicker(['/tmp/b.jpg']);

    await pumpPicker(
      tester,
      initial: [LocalCollageImage(XFile('/tmp/a.jpg'))],
      subscriptionLoaded: false,
    );

    await addPastTheQuota(tester);

    expect(
      find.textContaining('Impossible de vérifier votre abonnement'),
      findsOneWidget,
    );
    expect(find.text('Passer premium'), findsNothing);
  });

  testWidgets('adds only what the remaining quota allows', (tester) async {
    ImagePickerPlatform.instance =
        _FakeImagePicker(['/tmp/b.jpg', '/tmp/c.jpg', '/tmp/d.jpg']);

    final images = await pumpPicker(
      tester,
      initial: [LocalCollageImage(XFile('/tmp/a.jpg'))],
      maxImagesPerEvent: 3,
    );

    await tester.tap(find.byType(PolaroidCollageWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('event-image-grid-add-tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sélectionner plusieurs photos'));
    await tester.pumpAndSettle();

    expect(pathsOf(images), ['/tmp/a.jpg', '/tmp/b.jpg', '/tmp/c.jpg']);
  });
}
