import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/message.dart';
import 'package:rebuyproject/screens/chat_screen/chat_screen.dart';
import 'package:intl/intl.dart';

class MessagesController extends GetxController {
  final messages = <Message>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchConversations();
    super.onInit();
  }

  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        messages.clear();
        return;
      }

      final event = await FirebaseDatabase.instance
          .ref('chats')
          .orderByChild('participants/${user.uid}')
          .equalTo(true)
          .once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        List<Message> conversationsList = [];

        for (var entry in data.entries) {
          final conversationData = Map<String, dynamic>.from(
            entry.value as Map,
          );
          final conversationId = entry.key;

          // Get the other user's ID
          final participants = Map<String, dynamic>.from(
            conversationData['participants'] as Map,
          );
          final otherUserId = participants.keys.firstWhere(
            (id) => id != user.uid,
            orElse: () => '',
          );

          if (otherUserId.isEmpty) continue;

          // Get other user's info
          final otherUserEvent = await FirebaseDatabase.instance
              .ref('users/$otherUserId')
              .once();

          String otherUserName = 'User';
          String otherUserAvatar = 'https://i.pravatar.cc/150';

          if (otherUserEvent.snapshot.value != null) {
            final userData = Map<String, dynamic>.from(
              otherUserEvent.snapshot.value as Map,
            );
            otherUserName = userData['name'] ?? 'User';
            otherUserAvatar =
                userData['profile_image'] ?? 'https://i.pravatar.cc/150';
          }

          final lastMessage = conversationData['last_message'] ?? '';
          final lastSenderId = conversationData['last_sender_id'] ?? '';
          final isMine = lastSenderId == user.uid;

          // Format timestamp
          final lastMessageTime = conversationData['last_message_time'];
          String timeText = '';
          if (lastMessageTime != null) {
            final timestamp = DateTime.fromMillisecondsSinceEpoch(
              lastMessageTime as int,
            );
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final messageDate = DateTime(
              timestamp.year,
              timestamp.month,
              timestamp.day,
            );

            if (messageDate == today) {
              timeText = DateFormat('h:mm a').format(timestamp);
            } else if (messageDate == today.subtract(const Duration(days: 1))) {
              timeText = 'Yesterday ${DateFormat('h:mm a').format(timestamp)}';
            } else {
              timeText = DateFormat('MMM dd, yy, h:mm a').format(timestamp);
            }
          }

          conversationsList.add(
            Message(
              id: conversationId,
              conversationId: conversationId,
              productName: conversationData['product_name'] ?? 'Product',
              productId: conversationData['product_id'] ?? '',
              senderName: otherUserName,
              senderId: otherUserId,
              lastMessage: isMine ? 'You: $lastMessage' : lastMessage,
              time: timeText,
              avatarUrl: otherUserAvatar,
              isMine: isMine,
            ),
          );
        }

        // Sort by last message time
        conversationsList.sort((a, b) => b.time.compareTo(a.time));
        messages.assignAll(conversationsList);
        print('✅ Fetched ${conversationsList.length} conversations');
      } else {
        messages.clear();
        print('⚠️ No conversations found');
      }
    } catch (e) {
      print('❌ Error fetching conversations: $e');
      Get.snackbar('Error', 'Failed to load conversations');
    } finally {
      isLoading.value = false;
    }
  }

  void openChat(Message message) {
    Get.to(
      () => ChatScreen(
        conversationId: message.conversationId,
        productId: message.productId,
        productName: message.productName,
        otherUserId: message.senderId,
        otherUserName: message.senderName,
        otherUserAvatar: message.avatarUrl,
      ),
    );
  }
}
