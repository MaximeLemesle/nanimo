import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/event_polaroid_collage_widget.dart';

void main() {
  Future<String> resolver(String path) async => 'https://example.com/$path';

  /// Width the collage actually gets in the timeline: the journal page pads the
  /// list by [AppSpacing.lg] on both sides, and the card splits what is left
  /// between the photo column and the text column.
  double availableWidth(double screenWidth) =>
      (screenWidth - AppSpacing.lg * 2 - AppSpacing.lg) / 2;

  Widget wrap(Widget child, {required double width}) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      );

  Finder photoClips() => find.descendant(
        of: find.byType(JournalTimelinePolaroidCollageWidget),
        matching: find.byType(ClipRRect),
      );

  testWidgets('renders nothing without images', (tester) async {
    await tester.pumpWidget(
      wrap(
        JournalTimelinePolaroidCollageWidget(
          assetPaths: const [],
          urlResolver: resolver,
        ),
        width: availableWidth(375),
      ),
    );

    expect(photoClips(), findsNothing);
  });

  testWidgets('caps the collage at maxImages frames', (tester) async {
    await tester.pumpWidget(
      wrap(
        JournalTimelinePolaroidCollageWidget(
          assetPaths: const ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
          urlResolver: resolver,
        ),
        width: availableWidth(375),
      ),
    );

    expect(
      photoClips(),
      findsNWidgets(JournalTimelinePolaroidCollageWidget.maxImages),
    );
  });

  /// Regression (NAN-055): the Stack used to size itself on its largest frame,
  /// so the frames fanned out by Transform.translate fell outside its clip
  /// bounds and were cut on the sides.
  for (final screenWidth in [375.0, 393.0, 430.0]) {
    for (final imageCount in [2, 3, 4, 5]) {
      testWidgets(
        'keeps all $imageCount photos inside the collage on a ${screenWidth.toInt()}pt screen',
        (tester) async {
          await tester.pumpWidget(
            wrap(
              JournalTimelinePolaroidCollageWidget(
                assetPaths: List.generate(imageCount, (i) => 'photo-$i'),
                urlResolver: resolver,
              ),
              width: availableWidth(screenWidth),
            ),
          );

          final bounds =
              tester.getRect(find.byType(JournalTimelinePolaroidCollageWidget));
          final clips = photoClips();
          expect(clips, findsNWidgets(imageCount));

          for (var i = 0; i < imageCount; i++) {
            final photo = tester.getRect(clips.at(i));
            expect(
              bounds.inflate(0.01).contains(photo.topLeft) &&
                  bounds.inflate(0.01).contains(photo.bottomRight),
              isTrue,
              reason: 'photo $i at $photo escapes the collage bounds $bounds',
            );
          }
        },
      );
    }
  }

  testWidgets('does not scale the collage up on a wide layout', (tester) async {
    const paths = ['a', 'b', 'c'];
    await tester.pumpWidget(
      wrap(
        JournalTimelinePolaroidCollageWidget(
          assetPaths: paths,
          urlResolver: resolver,
        ),
        width: 600,
      ),
    );

    final wide = tester.getSize(photoClips().first);

    await tester.pumpWidget(
      wrap(
        JournalTimelinePolaroidCollageWidget(
          assetPaths: paths,
          urlResolver: resolver,
        ),
        width: 900,
      ),
    );

    expect(tester.getSize(photoClips().first), wide);
  });
}
