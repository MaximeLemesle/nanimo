/// Thrown when a repository write needs the network and the device is offline
class RepositoryNetworkException implements Exception {
  final String message;
  const RepositoryNetworkException(this.message);

  @override
  String toString() => message;
}
