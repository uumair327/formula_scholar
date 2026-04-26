// Exceptions thrown by the data sources.
// These should be caught by repositories and converted to Failures.

class ServerException implements Exception {
  const ServerException({this.message = 'Server Error'});
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  const CacheException({this.message = 'Cache Error'});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class CancelledException implements Exception {
  const CancelledException({this.message = 'Operation cancelled.'});
  final String message;

  @override
  String toString() => 'CancelledException: $message';
}
