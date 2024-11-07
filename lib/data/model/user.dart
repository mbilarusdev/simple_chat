import 'profile.dart';

class User {
  final String userId;
  final String username;
  final String passwordHash;
  final UserProfile? profile;
  final bool isOnline;
  User({
    required this.userId,
    required this.username,
    required this.passwordHash,
    this.profile,
    this.isOnline = false,
  });

  User copyWith({
    String? userId,
    String? username,
    String? passwordHash,
    UserProfile? profile,
    bool? isOnline,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      profile: profile ?? this.profile,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'username': username,
      'password_hash': passwordHash,
      'user_profile': profile?.toMap(),
      'is_online': isOnline,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'] as String,
      username: map['username'] as String,
      passwordHash: map['password_hash'] as String,
      profile: map['user_profile'] != null ? UserProfile.fromMap(map['user_profile'] as Map<String, dynamic>) : null,
      isOnline: (map['is_online'] as bool?) ?? false,
    );
  }

  @override
  String toString() {
    return 'User(user_id: $userId, username: $username, password_hash: $passwordHash, user_profile: $profile)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.username == username &&
        other.passwordHash == passwordHash &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ username.hashCode ^ passwordHash.hashCode ^ profile.hashCode;
  }
}
