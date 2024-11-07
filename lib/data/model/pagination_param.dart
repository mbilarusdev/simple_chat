class PaginationParam {
  final int page;
  final int perPage;
  PaginationParam({
    required this.page,
    required this.perPage,
  });

  PaginationParam copyWith({
    int? page,
    int? perPage,
  }) {
    return PaginationParam(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
  }

  factory PaginationParam.fromMap(Map<String, dynamic> map) {
    return PaginationParam(
      page: map['page'] as int,
      perPage: map['per_page'] as int,
    );
  }

  @override
  String toString() => 'PaginationParam(page: $page, per_page: $perPage)';

  @override
  bool operator ==(covariant PaginationParam other) {
    if (identical(this, other)) return true;

    return other.page == page && other.perPage == perPage;
  }

  @override
  int get hashCode => page.hashCode ^ perPage.hashCode;
}
