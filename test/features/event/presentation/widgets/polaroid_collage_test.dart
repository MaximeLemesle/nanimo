import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows the empty placeholder when no image is selected',
      (tester) async {
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(images: const [], onTap: () {}),
    ));

    expect(find.byIcon(Icons.photo), findsWidgets);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('renders a frame per picked image', (tester) async {
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(
        images: [XFile('a.jpg'), XFile('b.jpg')],
        onTap: () {},
      ),
    ));

    expect(find.byType(Image), findsNWidgets(2));
    expect(find.byIcon(Icons.photo), findsNothing);
  });

  testWidgets('forwards taps through onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(images: const [], onTap: () => tapped = true),
    ));

    await tester.tap(find.byType(PolaroidCollageWidget));
    expect(tapped, isTrue);
  });
}
