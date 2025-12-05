import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddListingController extends GetxController {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final makeController = TextEditingController();
  final yearController = TextEditingController();
  final hasWarranty = false.obs;
  final hasOriginalPacking = false.obs;
  final image = Rx<File?>(null);

  Future<void> pickImage(ImageSource source) async {
    try {

      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
        maxWidth: 600,
        maxHeight: 600,
      );
      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      }
    } catch (e) {

      if (e.toString().contains('already_active')) {
        Get.snackbar(
          'Error',
          'Image picker is already active. Please try again.',
        );
      } else {
        Get.snackbar('Error', 'Failed to pick image: $e');
      }
    }
  }

  Future<String?> uploadImage() async {
    if (image.value == null) {
      return null;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

 
    final bytes = await image.value!.readAsBytes();
    final base64String = base64Encode(bytes);
   
    return 'data:image/jpeg;base64,$base64String';
  }

  Future<void> addProduct() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'You must be logged in to add a product');
        return;
      }

      final imageUrl = await uploadImage();
      final newListingRef = FirebaseDatabase.instance.ref('listings').push();

      await newListingRef.set({
        'title': titleController.text,
        'subtitle': subtitleController.text,
        'price': priceController.text,
        'image_url': imageUrl,
        'description': descriptionController.text,
        'make': makeController.text,
        'year': yearController.text,
        'has_warranty': hasWarranty.value,
        'has_original_packing': hasOriginalPacking.value,
        'user_id': user.uid,
        'created_at': ServerValue.timestamp,
      });

      Get.back();
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    subtitleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    makeController.dispose();
    yearController.dispose();
    super.onClose();
  }
}
