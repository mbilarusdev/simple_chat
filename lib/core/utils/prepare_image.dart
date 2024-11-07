import 'dart:convert';
import 'dart:typed_data';

import 'package:simple_chat/data/model.dart';

Uint8List prepareImage(ImageModel image) {
  return base64Decode(image.bytes.replaceAll(RegExp(r'\s'), ''));
}
