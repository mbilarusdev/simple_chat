class HandshakeMessage {
  static const String messageType = 'handshake';
  final String? token;
  final bool? isSuccess;
  HandshakeMessage({
    this.token,
    this.isSuccess,
  });

  HandshakeMessage copyWith({
    String? token,
    bool? isSuccess,
  }) {
    return HandshakeMessage(
      token: token ?? this.token,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_type': messageType,
      'token': token,
      'is_success': isSuccess,
    };
  }

  factory HandshakeMessage.fromMap(Map<String, dynamic> map) {
    return HandshakeMessage(
      token: map['token'] != null ? map['token'] as String : null,
      isSuccess: map['is_success'] != null ? map['is_success'] as bool : null,
    );
  }

  @override
  String toString() => 'HandshakeMessage(message_type: $messageType, token: $token, is_success: $isSuccess)';

  @override
  bool operator ==(covariant HandshakeMessage other) {
    if (identical(this, other)) return true;

    return other.token == token && other.isSuccess == isSuccess;
  }

  @override
  int get hashCode => token.hashCode ^ isSuccess.hashCode;
}
