import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:simple_chat/core/helpers.dart';

import 'package:simple_chat/data/exception.dart';
import 'package:simple_chat/data/model.dart';

enum UserExceptionType { notUniqueUsername }

enum PasswordType { standart, hash }

class UserException implements Exception {
  UserExceptionType type;
  UserException._(this.type);
  factory UserException.notUniqueUsername() => UserException._(UserExceptionType.notUniqueUsername);
}

class UserRepository {
  final Dio dio;
  final SimpleChatSecureStorage secureStorage;
  const UserRepository({required this.dio, required this.secureStorage});

  Future<User> register(String username, String password, String avatarId) async {
    User? user;
    try {
      final profile = await createUserProfile(avatarId);
      user = User.fromMap((await dio.post<Map<String, dynamic>>(
        _UserRepositoryUrls.user,
        data: jsonEncode(
          Login(
            username: username,
            passwordHash: _createPasswordHash(password),
          ).toMap()
            ..['profile_id'] = profile.userProfileId,
        ),
      ))
          .data!);
    } on DioException catch (e, st) {
      if (e.response?.statusCode == HttpStatus.unprocessableEntity) {
        throw UserException.notUniqueUsername();
      }
      handleDioAppErrors(e, st);
    } catch (e, st) {
      print(e);
      print(st);
      throw AppException.other(e, st);
    }
    return user!;
  }

  Future<void> logout() async {
    await secureStorage.clearAuthorizationToken();
  }

  Future<User> login(
    String username,
    String password,
    PasswordType passwordType,
  ) async {
    User? user;

    try {
      await dio.post<Map<String, dynamic>>(
        _UserRepositoryUrls.login,
        data: jsonEncode(Login(
          username: username,
          passwordHash: passwordType == PasswordType.standart ? _createPasswordHash(password) : password,
        ).toMap()),
      );

      user = await getUser();
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      print(e);
      print(st);
      throw AppException.other(e, st);
    }
    return user!;
  }

  Future<UserProfile> createUserProfile(String avatarId) async {
    UserProfile? profile;
    try {
      profile = UserProfile.fromMap(
        (await dio.post<Map<String, dynamic>>(
          _UserRepositoryUrls.userProfile,
          data: {
            'avatar_id': avatarId,
          },
        ))
            .data!,
      );
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      throw AppException.other(e, st);
    }
    return profile!;
  }

  Future<User> getUser() async {
    User? user;
    try {
      user = User.fromMap(
        (await dio.get<Map<String, dynamic>>(
          _UserRepositoryUrls.user,
        ))
            .data!,
      );

      return user;
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      print(e);
      print(st);
      throw AppException.other(e, st);
    }
    return user!;
  }

  Future<List<User>> findUsers([FindUsers? param]) async {
    List<User>? users;
    try {
      users = ((await dio.get<List>(
        _UserRepositoryUrls.findUserByUsername,
        data: param != null ? jsonEncode(param.toMap()) : null,
      ))
              .data!)
          .map((userMap) => User.fromMap(userMap as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      throw AppException.other(e, st);
    }
    return users!;
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    UserProfile? userProfile;
    try {
      await dio.patch(
        _UserRepositoryUrls.userProfile,
        data: jsonEncode(profile.toMap()),
      );
      final user = await getUser();

      userProfile = user.profile!;
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      throw AppException.other(e, st);
    }
    return userProfile!;
  }

  String _createPasswordHash(String password) {
    final Uint8List bytes = utf8.encode(password);
    final Digest passwordHash = md5.convert(bytes);
    return passwordHash.toString();
  }
}

class _UserRepositoryUrls {
  static String get user => '/user';
  static String get login => '/login';
  static String get userProfile => '/user/profile';
  static String get findUserByUsername => '/user/byUsername';
}
