import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/core/error/failures.dart';

void main() {
  group('Result', () {
    test('Success holds data', () {
      const result = Success<int>(42);
      expect(result.data, 42);
    });

    test('Error holds failure', () {
      const failure = ServerFailure(message: 'timeout');
      const result = Error<int>(failure);
      expect(result.failure.message, 'timeout');
    });

    test('pattern matching works exhaustively', () {
      const Result<String> result = Success('hello');
      final output = switch (result) {
        Success(:final data) => 'Got: $data',
        Error(:final failure) => 'Err: ${failure.message}',
      };
      expect(output, 'Got: hello');
    });
  });

  group('Failure sealed class', () {
    test('ServerFailure is a Failure', () {
      const f = ServerFailure(message: 'server error');
      expect(f, isA<Failure>());
      expect(f.message, 'server error');
    });

    test('AuthFailure is a Failure', () {
      const f = AuthFailure(message: 'unauthorized');
      expect(f, isA<Failure>());
    });

    test('CacheFailure is a Failure', () {
      const f = CacheFailure(message: 'disk full');
      expect(f, isA<Failure>());
    });

    test('Equatable comparison works', () {
      const f1 = ServerFailure(message: 'x');
      const f2 = ServerFailure(message: 'x');
      const f3 = ServerFailure(message: 'y');
      expect(f1, equals(f2));
      expect(f1, isNot(equals(f3)));
    });
  });
}
