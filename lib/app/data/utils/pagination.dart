class Pagination {
  int page = 1;
  int limit = 1;
  Pagination({this.page = 1, this.limit = 1});

  @override
  String toString() => 'Pagination(skip: $page, limit: $limit)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pagination && other.page == page && other.limit == limit;
  }

  @override
  int get hashCode => page.hashCode ^ limit.hashCode;
}
