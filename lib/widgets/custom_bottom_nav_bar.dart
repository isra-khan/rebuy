import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/home_controller.dart'; // For navigation
import 'package:rebuyproject/utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final HomeController controller;

  const CustomBottomNavBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.textDark, // Dark grey/black background
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(icon: Icons.home_filled, index: 0, controller: controller),
          _buildNavItem(icon: Icons.explore_outlined, index: 1, controller: controller),
          _buildCenterNavItem(controller: controller),
          _buildNavItem(icon: Icons.favorite_border, index: 3, controller: controller),
          _buildNavItem(icon: Icons.chat_bubble_outline, index: 4, controller: controller),
        ],
      )),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required HomeController controller,
  }) {
    final isSelected = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.onBottomNavTapped(index),
      child: Container(
        width: 40,
        height: 40,
        decoration: isSelected
            ? const BoxDecoration(
                color: Color(0xFF36898B), // Teal color
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey.shade400,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCenterNavItem({required HomeController controller}) {
    return GestureDetector(
      onTap: () {
        // Camera/Sell action
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: AppColors.textDark,
          size: 28,
        ),
      ),
    );
  }
}

