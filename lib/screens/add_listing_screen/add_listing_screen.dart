import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rebuyproject/controllers/add_listing_controller.dart';
import 'package:rebuyproject/utils/app_colors.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddListingController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff555555)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Color(0xff555555),
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Text(
                    'Add Listing',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Obx(() => controller.image.value == null
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () =>
                                  controller.pickImage(ImageSource.camera),
                            ),
                            IconButton(
                              icon: const Icon(Icons.photo_library),
                              onPressed: () =>
                                  controller.pickImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Image.file(
                      controller.image.value!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.titleController,
                label: 'Title',
                hint: 'Enter title',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.subtitleController,
                label: 'Subtitle',
                hint: 'Enter subtitle',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.priceController,
                label: 'Price',
                hint: 'Enter price',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.descriptionController,
                label: 'Description',
                hint: 'Enter description',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.makeController,
                label: 'Make',
                hint: 'Enter make',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.yearController,
                label: 'Year',
                hint: 'Enter year',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Has Warranty'),
                  Obx(() => Checkbox(
                        value: controller.hasWarranty.value,
                        onChanged: (value) =>
                            controller.hasWarranty.value = value!,
                      )),
                ],
              ),
              Row(
                children: [
                  const Text('Has Original Packing'),
                  Obx(() => Checkbox(
                        value: controller.hasOriginalPacking.value,
                        onChanged: (value) =>
                            controller.hasOriginalPacking.value = value!,
                      )),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientStart.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffDEDEDE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Color(0xff6F6F6F)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          labelStyle: const TextStyle(color: AppColors.textLight),
        ),
      ),
    );
  }
}
