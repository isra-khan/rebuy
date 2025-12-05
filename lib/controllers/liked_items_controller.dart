import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';

class LikedItemsController extends GetxController {
  final RxInt currentPage = 1.obs;
  final likedItems = <Product>[].obs;

  @override
  void onInit() {
    fetchLikedItems();
    super.onInit();
  }

  Future<void> fetchLikedItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      
      // 1. Get all favorite entries for this user
      final favoritesEvent = await FirebaseDatabase.instance
          .ref('favorites')
          .orderByChild('user_id')
          .equalTo(user.uid)
          .once();

      if (favoritesEvent.snapshot.value == null) {
        likedItems.clear();
        return;
      }

      final favoritesData = Map<String, dynamic>.from(favoritesEvent.snapshot.value as Map);
      final productIds = favoritesData.values
          .map((e) => e['product_id'] as String)
          .toSet() // Use set to avoid duplicates
          .toList();

      if (productIds.isEmpty) {
        likedItems.clear();
        return;
      }

   
      List<Product> products = [];
      for (var productId in productIds) {
        final productEvent = await FirebaseDatabase.instance
            .ref('listings/$productId')
            .once();
            
        if (productEvent.snapshot.value != null) {
           final data = Map<String, dynamic>.from(productEvent.snapshot.value as Map);
           data['id'] = productId;
           products.add(Product.fromJson(data));
        }
      }

      likedItems.value = products;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'You must be logged in');
        return;
      }

      // Find and remove the favorite entry
      final event = await FirebaseDatabase.instance
          .ref('favorites')
          .orderByChild('user_id')
          .equalTo(user.uid)
          .once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        final keysToDelete = <String>[];
        data.forEach((key, value) {
          if (value['product_id'] == product.id) {
            keysToDelete.add(key);
          }
        });
        
        // Delete after iteration
        for (var key in keysToDelete) {
          await FirebaseDatabase.instance.ref('favorites/$key').remove();
        }
      }

      // Remove from local list immediately for better UX
      likedItems.removeWhere((p) => p.id == product.id);
  
    } catch (e) {
      
      Get.snackbar('Error', e.toString());
    }
  }
}
