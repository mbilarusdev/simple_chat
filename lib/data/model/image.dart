class ImageModel {
  final String? imageId;
  final String fileName;
  final String format;
  final String bytes;
  ImageModel({
    this.imageId,
    required this.fileName,
    required this.format,
    required this.bytes,
  });

  ImageModel copyWith({
    String? imageId,
    String? fileName,
    String? format,
    String? bytes,
  }) {
    return ImageModel(
      imageId: imageId ?? this.imageId,
      fileName: fileName ?? this.fileName,
      format: format ?? this.format,
      bytes: bytes ?? this.bytes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image_id': imageId,
      'file_name': fileName,
      'format': format,
      'bytes': bytes,
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      imageId: map['image_id'] != null ? map['image_id'] as String : null,
      fileName: map['file_name'] as String,
      format: map['format'] as String,
      bytes: map['bytes'] as String,
    );
  }

  @override
  String toString() {
    return 'ImageModel(image_id: $imageId, file_name: $fileName, format: $format, bytes: $bytes)';
  }

  @override
  bool operator ==(covariant ImageModel other) {
    if (identical(this, other)) return true;

    return other.imageId == imageId && other.fileName == fileName && other.format == format && other.bytes == bytes;
  }

  @override
  int get hashCode {
    return imageId.hashCode ^ fileName.hashCode ^ format.hashCode ^ bytes.hashCode;
  }
}
