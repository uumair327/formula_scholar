import 'package:equatable/equatable.dart';

/// A standard generic wrapper for paginated collections.
///
/// Follows industry-grade backend architectural standards by returning
/// the list of items [data], a boolean [hasMore] flag for infinite
/// scrolling, and a [lastCursorId] string to pass to the next query.
class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final bool hasMore;
  final String? lastCursorId;

  const PaginatedResponse({
    required this.data,
    required this.hasMore,
    this.lastCursorId,
  });

  @override
  List<Object?> get props => [data, hasMore, lastCursorId];
}
