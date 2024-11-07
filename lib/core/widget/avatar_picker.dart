import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_chat/core/bloc/image_picker_bloc.dart';

import 'package:simple_chat/core/widget/snackbar.dart';
import 'package:simple_chat/data/repository/image_repository.dart';

class AvatarPicker extends StatefulWidget {
  final bool needDispose;
  const AvatarPicker({super.key, this.needDispose = false});

  @override
  State<AvatarPicker> createState() => AvatarPickerState();
}

class AvatarPickerState extends State<AvatarPicker> {
  late final ImagePickerBloc imagePickerBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        imagePickerBloc = ImagePickerBloc(context.read<ImageRepository>());
        return imagePickerBloc;
      },
      child: BlocConsumer<ImagePickerBloc, ImagePickerState>(
        listener: (context, state) {
          if (state is ImagePickerFailed) {
            SimpleChatSnackbar.show(text: state.error);
          }
        },
        builder: (context, state) => GestureDetector(
          onTap: () async {
            final picker = ImagePicker();

            final xfile = await picker.pickImage(source: ImageSource.gallery);
            if (xfile != null) {
              if (!context.mounted) return;
              context.read<ImagePickerBloc>().add(ImagePickerUploadRequested(xfile));
            }
          },
          child: SizedBox(
            height: 128,
            width: 128,
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: state is ImagePickerSuccess ? null : Colors.white,
                  backgroundImage: state is ImagePickerSuccess ? state.imageMemory : null,
                  radius: 64.0,
                ),
                if (state is ImagePickerInUploadProccess)
                  const Center(child: SizedBox(width: 36, height: 36, child: CircularProgressIndicator())),
                if (state is ImagePickerFailed || state is ImagePickerInitial)
                  const Center(
                    child: Icon(
                      Icons.image,
                      size: 36.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() async {
    if (widget.needDispose) {
      imagePickerBloc.add(ImagePickerDecline());
    }
    super.deactivate();
  }
}
