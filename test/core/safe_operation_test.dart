import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/core/utils/safe_operation.dart';

void main() {
  group('safeOperation', () {
    test('returns Success when execute succeeds', () async {
      final result = await safeOperation<String>(
        tag: 'test',
        operation: 'fetchData',
        execute: () async => 'hello',
      );

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'hello');
    });

    test('returns Error when execute throws', () async {
      final result = await safeOperation<String>(
        tag: 'test',
        operation: 'fetchData',
        execute: () async => throw Exception('boom'),
      );

      expect(result, isA<Error<String>>());
    });

    test('uses fallback when execute throws and fallback succeeds', () async {
      final result = await safeOperation<String>(
        tag: 'test',
        operation: 'fetchData',
        execute: () async => throw Exception('network error'),
        fallback: () async => 'cached_value',
      );

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'cached_value');
    });

    test('returns Error when both execute and fallback fail', () async {
      final result = await safeOperation<String>(
        tag: 'test',
        operation: 'fetchData',
        execute: () async => throw Exception('network error'),
        fallback: () async => null,
      );

      expect(result, isA<Error<String>>());
    });
  });
}
