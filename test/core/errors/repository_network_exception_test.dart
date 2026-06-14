import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';

void main() {
  test('exposes its message and uses it as toString', () {
    const exception = RepositoryNetworkException('offline');

    expect(exception.message, 'offline');
    expect(exception.toString(), 'offline');
    expect(exception, isA<Exception>());
  });
}
