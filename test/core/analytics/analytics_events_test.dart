import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';

void main() {
  test('memory counts fall into stable buckets', () {
    expect(
      [0, 1, 2, 4, 5, 9, 10, 24, 25, 300].map(memoryCountBucket),
      ['0', '1', '2-4', '2-4', '5-9', '5-9', '10-24', '10-24', '25+', '25+'],
    );
  });

  test('a species code drops the breed variant of the icon key', () {
    expect(speciesCode('cat-europeen'), 'cat');
    expect(speciesCode('dog-border_collie'), 'dog');
    expect(speciesCode('rabbit'), 'rabbit');
  });
}
