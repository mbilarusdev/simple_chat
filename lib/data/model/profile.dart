import 'package:simple_chat/data/model.dart';

class UserProfile {
  final String userProfileId;
  final String? userStatus;
  final String? aboutMe;
  final String? avatarId;
  final ImageModel? avatar;

  UserProfile({
    required this.userProfileId,
    this.userStatus,
    this.aboutMe,
    this.avatarId,
    this.avatar,
  });

  UserProfile copyWith({
    String? userProfileId,
    String? userStatus,
    String? aboutMe,
    String? avatarId,
    ImageModel? avatar,
  }) {
    return UserProfile(
      userProfileId: userProfileId ?? this.userProfileId,
      userStatus: userStatus ?? this.userStatus,
      aboutMe: aboutMe ?? this.aboutMe,
      avatarId: avatarId ?? this.avatarId,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_profile_id': userProfileId,
      'user_status': userStatus,
      'about_me': aboutMe,
      'avatar_id': avatarId,
      'user_avatar': avatar?.toMap(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userProfileId: map['user_profile_id'] as String,
      userStatus: map['user_status'] != null ? map['user_status'] as String : null,
      aboutMe: map['about_me'] != null ? map['about_me'] as String : null,
      avatarId: map['avatar_id'] != null ? map['avatar_id'] as String : null,
      avatar: map['user_avatar'] != null ? ImageModel.fromMap(map['user_avatar'] as Map<String, dynamic>) : null,
    );
  }

  @override
  String toString() {
    return 'UserProfile(user_profile_id: $userProfileId, user_status: $userStatus, about_me: $aboutMe, avatar_id: $avatarId, user_avatar: $avatar)';
  }

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.userProfileId == userProfileId &&
        other.userStatus == userStatus &&
        other.aboutMe == aboutMe &&
        other.avatarId == avatarId &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return userProfileId.hashCode ^ userStatus.hashCode ^ aboutMe.hashCode ^ avatarId.hashCode ^ avatar.hashCode;
  }
}
