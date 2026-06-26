import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/add_image_bottom_sheet_widget.dart';

void main() {
  Widget harness() => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AddImageBottomSheetWidget.show(context),
              child: const Text('open'),
            ),
          ),
        ),
      );

  testWidgets('renders the three photo sources', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Que voulez-vous faire ?'), findsOneWidget);
    expect(find.text('Prendre une photo'), findsOneWidget);
    expect(find.text('Sélectionner une photo'), findsOneWidget);
    expect(find.text('Sélectionner plusieurs photos'), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byIcon(Icons.collections_outlined), findsOneWidget);
  });
}
