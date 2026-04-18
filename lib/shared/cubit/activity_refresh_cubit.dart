import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';

/// Shared signal cubit for cross-feature refresh requests.
///
/// Emits an incrementing integer token whenever learning activity changes,
/// allowing listening cubits to re-fetch backend-backed state.
@lazySingleton
class ActivityRefreshCubit extends Cubit<int> {
  ActivityRefreshCubit() : super(0);

  void notifyProgressUpdated() {
    final nextToken = state + 1;
    AppLogger.debug(
      'Progress refresh signal emitted: $nextToken',
      tag: AppLogTags.activityRefreshCubit,
    );
    emit(nextToken);
  }
}
