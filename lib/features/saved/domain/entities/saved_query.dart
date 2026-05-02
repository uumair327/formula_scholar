import 'package:equatable/equatable.dart';

/// Sort direction for saved content queries.
enum SortDirection { asc, desc }

/// Query controls for saved content retrieval (server-side authority).
///
/// Follows golden rule: Sorting authority must be at Firestore query level,
/// not in-memory. All sort clauses are applied in the adapter when building
/// the Firestore query.
class SavedQuery extends Equatable {
  const SavedQuery({
    this.searchQuery = '',
    this.sortByField = 'savedAt',
    this.sortDirection = SortDirection.desc,
  });

  /// Search text to filter results (applied in-memory after Firestore fetch).
  final String searchQuery;

  /// Firestore field name to sort by (e.g., 'title', 'savedAt', 'subject').
  /// Applied as orderBy() in Firestore query.
  final String sortByField;

  /// Sort direction: ascending or descending.
  /// Applied as descending parameter in orderBy() clause.
  final SortDirection sortDirection;

  /// Whether to sort in descending order.
  bool get isDescending => sortDirection == SortDirection.desc;

  SavedQuery copyWith({
    String? searchQuery,
    String? sortByField,
    SortDirection? sortDirection,
  }) {
    return SavedQuery(
      searchQuery: searchQuery ?? this.searchQuery,
      sortByField: sortByField ?? this.sortByField,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }

  @override
  List<Object?> get props => [searchQuery, sortByField, sortDirection];
}
