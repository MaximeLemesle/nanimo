import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/presentation/event_type_styles.dart';

void main() {
  group('EventTypeStyle.fromCode', () {
    test('resolves the known codes to their style', () {
      expect(EventTypeStyle.fromCode('balade'), EventTypeStyle.balade);
      expect(EventTypeStyle.fromCode('calin'), EventTypeStyle.calin);
      expect(
        EventTypeStyle.fromCode('anniversaire'),
        EventTypeStyle.anniversaire,
      );
    });

    test('falls back to the simple balade card for null/unknown codes', () {
      expect(EventTypeStyle.fromCode(null), EventTypeStyle.balade);
      expect(EventTypeStyle.fromCode('inconnu'), EventTypeStyle.balade);
      expect(EventTypeStyle.balade.cardStyle, EventCardStyle.simple);
    });
  });
}
