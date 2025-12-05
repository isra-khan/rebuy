import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';

class MyListingsController extends GetxController {
  final RxInt currentPage = 1.obs;
  final myListings = <Product>[].obs;

  @override
  void onInit() {
    fetchMyListings();
    super.onInit();
  }

  Future<void> fetchMyListings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      
      final event = await FirebaseDatabase.instance
          .ref('listings')
          .orderByChild('user_id')
          .equalTo(user.uid)
          .once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        myListings.value = data.entries.map((e) {
          final productData = Map<String, dynamic>.from(e.value as Map);
          productData['id'] = e.key;
          return Product.fromJson(productData);
        }).toList();
      } else {
        myListings.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
