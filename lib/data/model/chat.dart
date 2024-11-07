import 'package:simple_chat/data/model/image.dart';

class Chat {
  final String? chatId;
  final String title;
  final String imageId;
  final ImageModel? image;

  Chat({
    this.chatId,
    required this.title,
    required this.imageId,
    this.image,
  });

  Chat copyWith({
    String? chatId,
    String? title,
    String? imageId,
    ImageModel? image,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      title: title ?? this.title,
      imageId: imageId ?? this.imageId,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatId,
      'title': title,
      'image_id': imageId,
      'chat_image': image?.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatId: map['chat_id'] as String?,
      title: map['title'] as String,
      imageId: map['image_id'] as String,
      image: map['chat_image'] != null ? ImageModel.fromMap(map['chat_image'] as Map<String, dynamic>) : null,
    );
  }

  @override
  String toString() => 'Chat(chat_id: $chatId, title: $title, image_id: $imageId, chat_image: $image)';

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.chatId == chatId && other.title == title && other.imageId == imageId && other.image == image;
  }

  @override
  int get hashCode => chatId.hashCode ^ title.hashCode ^ imageId.hashCode ^ image.hashCode;
}
