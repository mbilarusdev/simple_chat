class FindUsers {
  final String username;
  final int page;
  final int perPage;
  FindUsers({
    required this.username,
    required this.page,
    required this.perPage,
  });

  FindUsers copyWith({String? username, int? page, int? perPage}) {
    return FindUsers(
      username: username ?? this.username,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'page': page,
      'per_page': perPage,
    };
  }

  factory FindUsers.fromMap(Map<String, dynamic> map) {
    return FindUsers(
      username: map['username'] as String,
      page: map['page'] as int,
      perPage: map['per_page'] as int,
    );
  }

  @override
  String toString() => 'FindUsers(username: $username, page: $page, per_page: $perPage)';

  @override
  bool operator ==(covariant FindUsers other) {
    if (identical(this, other)) return true;

    return other.username == username && other.page == page && other.perPage == perPage;
  }

  @override
  int get hashCode => username.hashCode ^ page.hashCode ^ perPage.hashCode;
}
