import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/my_account_controller.dart';
import 'package:rebuyproject/utils/app_colors.dart';

import 'package:image_picker/image_picker.dart';
import 'package:rebuyproject/widgets/universal_image.dart';
import 'package:rebuyproject/screens/home_screen/widgets/app_drawer.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';

class MyAccountScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAccountController());

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Profile and Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _showImagePickerOptions(context, controller),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff3C3C3C),
                                width: 4,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Obx(() {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    controller.profileImage.value != null
                                    ? UniversalImageProvider(
                                        controller.profileImage.value!,
                                      )
                                    : const NetworkImage(
                                            'https://i.pravatar.cc/150?u=alice',
                                          )
                                          as ImageProvider,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: controller.nameController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEF5350),
                                ),
                              ),
                              TextField(
                                controller: controller.emailController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff979797),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: ResponsiveIconSize.large,
                      color: Color(0xff3C3C3C),
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),

              const Text(
                'My account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildLabel('Name:'),
              const SizedBox(height: 8),
              _buildEditableField(controller.nameController),
              const SizedBox(height: 16),

              _buildLabel('Email:'),
              const SizedBox(height: 8),
              _buildEditableField(controller.emailController),
              const SizedBox(height: 16),

              _buildLabel('Phone:'),
              const SizedBox(height: 8),
              _buildEditableField(controller.phoneController),
              const SizedBox(height: 16),

              _buildLabel('Address:'),
              const SizedBox(height: 8),
              _buildEditableField(controller.addressController, maxLines: 4),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gradientStart,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Settings Button
              OutlinedButton.icon(
                onPressed: controller.openSettings,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  side: const BorderSide(color: AppColors.textDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.settings, color: AppColors.textDark),
                label: const Text(
                  'Settings',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildEditableField(
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB), // Light grey background for inputs
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ), // Adjusted padding
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: Colors.grey.shade800, // Darker text for editable
          fontSize: 16,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
          ), // Align text vertically
        ),
      ),
    );
  }

  void _showImagePickerOptions(
    BuildContext context,
    MyAccountController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
