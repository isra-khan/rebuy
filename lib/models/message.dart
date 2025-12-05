class Message {
  final String id;
  final String productName;
  final String productId;
  final String senderName;
  final String senderId;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isOnline;
  final int unreadCount;
  final bool isMine; // if the last message was sent by me
  final String conversationId;

  Message({
    required this.id,
    required this.productName,
    this.productId = '',
    required this.senderName,
    this.senderId = '',
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.isOnline = false,
    this.unreadCount = 0,
    this.isMine = false,
    this.conversationId = '',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      productId: json['product_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderId: json['sender_id'] ?? '',
      lastMessage: json['last_message'] ?? '',
      time: json['time'] ?? '',
      avatarUrl: json['avatar_url'] ?? 'https://i.pravatar.cc/150',
      isOnline: json['is_online'] ?? false,
      unreadCount: json['unread_count'] ?? 0,
      isMine: json['is_mine'] ?? false,
      conversationId: json['conversation_id'] ?? '',
    );
  }
}
