class Login {
  final String username;
  final String passwordHash;
  Login({
    required this.username,
    required this.passwordHash,
  });

  Login copyWith({
    String? username,
    String? passwordHash,
  }) {
    return Login(
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password_hash': passwordHash,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      username: map['username'] as String,
      passwordHash: map['password_hash'] as String,
    );
  }

  @override
  String toString() => 'LoginRegisterRequestModel(username: $username, password_hash: $passwordHash)';

  @override
  bool operator ==(covariant Login other) {
    if (identical(this, other)) return true;

    return other.username == username && other.passwordHash == passwordHash;
  }

  @override
  int get hashCode => username.hashCode ^ passwordHash.hashCode;
}
