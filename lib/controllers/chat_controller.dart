import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/chat_message.dart';

class ChatController extends GetxController {
  final String conversationId;
  final String productId;
  final String productName;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;

  ChatController({
    required this.conversationId,
    required this.productId,
    required this.productName,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
  });

  final messages = <ChatMessage>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchMessages();
    listenToMessages();
    super.onInit();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void listenToMessages() {
    FirebaseDatabase.instance
        .ref('chats/$conversationId/messages')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data['id'] = event.snapshot.key;
        final newMessage = ChatMessage.fromJson(data);
        
        // Check if message already exists
        if (!messages.any((m) => m.id == newMessage.id)) {
          messages.add(newMessage);
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          
          // Scroll to bottom
          Future.delayed(const Duration(milliseconds: 100), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final event = await FirebaseDatabase.instance
          .ref('chats/$conversationId/messages')
          .once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        List<ChatMessage> fetchedMessages = [];
        
        data.forEach((key, value) {
          final messageData = Map<String, dynamic>.from(value as Map);
          messageData['id'] = key;
          fetchedMessages.add(ChatMessage.fromJson(messageData));
        });

        fetchedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        messages.assignAll(fetchedMessages);
        
        // Scroll to bottom after loading
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });
      }
    } catch (e) {
    
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'You must be logged in to send messages');
        return;
      }

      final messageRef = FirebaseDatabase.instance
          .ref('chats/$conversationId/messages')
          .push();

      final message = ChatMessage(
        id: messageRef.key!,
        senderId: user.uid,
        senderName: user.displayName ?? 'User',
        message: text,
        timestamp: DateTime.now(),
        isRead: false,
      );

      await messageRef.set(message.toJson());

      // Update conversation metadata
      await FirebaseDatabase.instance
          .ref('chats/$conversationId')
          .update({
        'last_message': text,
        'last_message_time': DateTime.now().millisecondsSinceEpoch,
        'last_sender_id': user.uid,
      });

      messageController.clear();
     
    } catch (e) {
      
      Get.snackbar('Error', 'Failed to send message');
    }
  }
}

