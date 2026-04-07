// Exceptions thrown by the data sources.
// These should be caught by repositories and converted to Failures.

class ServerException implements Exception {
  final String message;

  const ServerException({this.message = 'Server Error'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache Error'});

  @override
  String toString() => 'CacheException: $message';
}

class CancelledException implements Exception {
  final String message;

  const CancelledException({this.message = 'Operation cancelled.'});

  @override
  String toString() => 'CancelledException: $message';
}
