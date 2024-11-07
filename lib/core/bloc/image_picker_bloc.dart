import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/utils.dart';
import 'package:simple_chat/data/model/image.dart';
import 'package:simple_chat/data/repository/image_repository.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImageRepository imageRepository;
  ImagePickerBloc(this.imageRepository) : super(ImagePickerInitial()) {
    on<ImagePickerUploadRequested>(_uploadRequested);
    on<ImagePickerDecline>(_decline);
  }

  Future<void> _uploadRequested(ImagePickerUploadRequested event, Emitter<ImagePickerState> emit) async {
    try {
      if (state is! ImagePickerInUploadProccess) {
        if (state is ImagePickerSuccess) {
          await imageRepository.deleteImage((state as ImagePickerSuccess).imageModel.imageId!);
        }
        final file = event.file;
        final cancelToken = CancelToken();

        ImageModel? image;
        if (['jpg', 'png', 'jpeg'].map((format) => file.path.endsWith(format)).contains(true)) {
          image = ImageModel(
            bytes: base64Encode((await file.readAsBytes())),
            fileName: file.name,
            format: file.path.split('.').last,
          );
          emit(ImagePickerInUploadProccess(cancelToken));
          ImageModel uploadedImage = await imageRepository.uploadImage(image, cancelToken);
          final imageMemory = MemoryImage(prepareImage(uploadedImage));
          emit(ImagePickerSuccess(imageMemory, uploadedImage));
        } else {
          emit(ImagePickerFailed('Поддерживаемые форматы: .jpg, .png, .jpeg'));
        }
      }
    } catch (e) {
      emit(ImagePickerFailed(Texts.errorOccuredCheckInternetConnection));
    }
  }

  // Нужен для того, чтобы удалить картинку на беке, если она в итоге не будет использоваться.
  //
  // Реализуется через dispose в случае когда state бизнес процесса != success
  Future<void> _decline(ImagePickerDecline event, Emitter<ImagePickerState> emit) async {
    try {
      if (state is ImagePickerInUploadProccess) {
        final cancelToken = (state as ImagePickerInUploadProccess).cancelToken;
        cancelToken.cancel();
      }
      if (state is ImagePickerSuccess) {
        await imageRepository.deleteImage((state as ImagePickerSuccess).imageModel.imageId!);
      }
    } catch (e) {
      emit(ImagePickerFailed(Texts.errorOccuredCheckInternetConnection));
    }
  }
}

sealed class ImagePickerEvent {}

final class ImagePickerUploadRequested extends ImagePickerEvent {
  final XFile file;
  ImagePickerUploadRequested(this.file);
}

final class ImagePickerDecline extends ImagePickerEvent {}

sealed class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}

final class ImagePickerInUploadProccess extends ImagePickerState {
  CancelToken cancelToken;
  ImagePickerInUploadProccess(this.cancelToken);
}

final class ImagePickerSuccess extends ImagePickerState {
  final MemoryImage imageMemory;
  final ImageModel imageModel;
  ImagePickerSuccess(this.imageMemory, this.imageModel);
}

final class ImagePickerFailed extends ImagePickerState {
  final String error;
  ImagePickerFailed(this.error);
}
