import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
@LazySingleton(as: OnboardingRepositoryPort)
class OnboardingRepositoryImpl implements OnboardingRepositoryPort {
  OnboardingRepositoryImpl(this._dataSource);
  final OnboardingDataSourcePort _dataSource;

  @override
  Future<Result<PaginatedResponse<Country>>> getCountries({
    int limit = 20,
    String? startAfterId,
  }) async {
    try {
      final result = await _dataSource.getCountries(
        limit: limit,
        startAfterId: startAfterId,
      );
      return Success(result);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to get countries',
        error: e,
        stackTrace: stack,
        tag: AppLogTags.onboardingRepo,
      );
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<PaginatedResponse<StateRegion>>> getStates(
    String countryId, {
    int limit = 20,
    String? startAfterId,
  }) async {
    try {
      final result = await _dataSource.getStates(
        countryId,
        limit: limit,
        startAfterId: startAfterId,
      );
      return Success(result);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to get states',
        error: e,
        stackTrace: stack,
        tag: AppLogTags.onboardingRepo,
      );
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<PaginatedResponse<Board>>> getBoards(
    String countryId, {
    String? stateId,
    int limit = 20,
    String? startAfterId,
  }) async {
    try {
      final result = await _dataSource.getBoards(
        countryId,
        stateId: stateId,
        limit: limit,
        startAfterId: startAfterId,
      );
      return Success(result);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to get boards',
        error: e,
        stackTrace: stack,
        tag: AppLogTags.onboardingRepo,
      );
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<PaginatedResponse<Grade>>> getGrades(
    String boardId, {
    int limit = 20,
    String? startAfterId,
  }) async {
    try {
      final result = await _dataSource.getGrades(
        boardId,
        limit: limit,
        startAfterId: startAfterId,
      );
      return Success(result);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to get grades',
        error: e,
        stackTrace: stack,
        tag: AppLogTags.onboardingRepo,
      );
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
