import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final profileImage = Rx<String?>(null);

  // Observable variables for UI binding
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();

    // Keep observables in sync with text controllers when editing
    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    phoneController.addListener(() => phone.value = phoneController.text);
    addressController.addListener(() => address.value = addressController.text);
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final event = await FirebaseDatabase.instance
        .ref('users/${user.uid}')
        .once();

    if (event.snapshot.value != null) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? user.email ?? '';
      phoneController.text = data['phone'] ?? '';
      addressController.text = data['address'] ?? '';
      profileImage.value = data['profile_image'];

      // Update observables
      name.value = nameController.text;
      email.value = emailController.text;
      phone.value = phoneController.text;
      address.value = addressController.text;
    } else {
      // Pre-fill email from Auth if no DB record
      emailController.text = user.email ?? '';
      nameController.text = user.displayName ?? '';

      // Update observables
      email.value = emailController.text;
      name.value = nameController.text;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
        maxWidth: 400,
        maxHeight: 400,
      );
      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        final base64String = base64Encode(bytes);
        profileImage.value = 'data:image/jpeg;base64,$base64String';
        await saveUserData(); // Auto-save on image change
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseDatabase.instance.ref('users/${user.uid}').set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'profile_image': profileImage.value,
      });
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  void openSettings() {
    Get.snackbar('Settings', 'Open settings page');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
