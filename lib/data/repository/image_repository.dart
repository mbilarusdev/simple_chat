import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simple_chat/data/exception.dart';
import 'package:simple_chat/data/model/image.dart';

class ImageRepository {
  final Dio dio;
  const ImageRepository({required this.dio});

  Future<ImageModel> uploadImage(ImageModel image, [CancelToken? token]) async {
    ImageModel? profile;
    try {
      profile = ImageModel.fromMap(
        (await dio.post<Map<String, dynamic>>(_ImageRepositoryUrls.image,
                data: jsonEncode(image.toMap()), cancelToken: token))
            .data!,
      );
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      throw AppException.other(e, st);
    }
    return profile!;
  }

  Future<void> deleteImage(String imageId) async {
    try {
      await dio.delete<Map<String, dynamic>>(_ImageRepositoryUrls.image, data: jsonEncode({'image_id': imageId}));
    } on DioException catch (e, st) {
      handleDioAppErrors(e, st);
    } catch (e, st) {
      throw AppException.other(e, st);
    }
  }
}

class _ImageRepositoryUrls {
  static String get image => '/image';
}
