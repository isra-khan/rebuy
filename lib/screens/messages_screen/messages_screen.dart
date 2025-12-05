import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/home_controller.dart';
import 'package:rebuyproject/controllers/messages_controller.dart';
import 'package:rebuyproject/models/message.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/widgets/custom_bottom_nav_bar.dart';
import 'package:rebuyproject/screens/home_screen/widgets/app_drawer.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController());
    final homeController = Get.find<HomeController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(controller: homeController),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff555555)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => homeController.onBottomNavTapped(0),
                    ),
                  ),
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: ResponsiveIconSize.large,
                      color: AppColors.textDark,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffDEDEDE),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search in messages...',
                    hintStyle: TextStyle(
                      color: Color(0xff828282),
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(Icons.search, color: Color(0xff999999)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Messages List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff979797),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageTile(controller.messages[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(Message message) {
    return GestureDetector(
      onTap: () => Get.find<MessagesController>().openChat(message),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
              if (message.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey, // Offline/Idle
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${message.productName} | ${message.senderName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  message.lastMessage,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF5350),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${message.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                message.time,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
