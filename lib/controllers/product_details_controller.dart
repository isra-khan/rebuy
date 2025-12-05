import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/chat_screen/chat_screen.dart';
import 'package:rebuyproject/screens/purchase_form_screen/purchase_form_screen.dart';

class ProductDetailsController extends GetxController {
  final Product product;

  ProductDetailsController(this.product);
  
  final RxInt currentImageIndex = 0.obs;

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  Future<void> contactSeller() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'Please login to contact the seller');
        return;
      }

      // Don't allow users to contact themselves
      if (product.id.isNotEmpty && user.uid == product.id) {
        Get.snackbar('Info', 'You cannot message yourself');
        return;
      }

      // Get seller info (in a real app, product should have sellerId)
      // For now, we'll use the product's user_id from the database
      final productEvent = await FirebaseDatabase.instance
          .ref('listings/${product.id}')
          .once();

      if (productEvent.snapshot.value == null) {
        Get.snackbar('Error', 'Product not found');
        return;
      }

      final productData = Map<String, dynamic>.from(productEvent.snapshot.value as Map);
      final sellerId = productData['user_id'] ?? '';

      if (sellerId.isEmpty) {
        Get.snackbar('Error', 'Seller information not available');
        return;
      }

      if (sellerId == user.uid) {
        Get.snackbar('Info', 'This is your own listing');
        return;
      }

      // Get seller info
      final sellerEvent = await FirebaseDatabase.instance
          .ref('users/$sellerId')
          .once();

      String sellerName = 'Seller';
      String sellerAvatar = 'https://i.pravatar.cc/150';

      if (sellerEvent.snapshot.value != null) {
        final sellerData = Map<String, dynamic>.from(sellerEvent.snapshot.value as Map);
        sellerName = sellerData['name'] ?? 'Seller';
        sellerAvatar = sellerData['profile_image'] ?? 'https://i.pravatar.cc/150';
      }

      // Create conversation ID (consistent format: smaller_uid_larger_uid_productId)
      final userIds = [user.uid, sellerId]..sort();
      final conversationId = '${userIds[0]}_${userIds[1]}_${product.id}';

      // Check if conversation exists
      final conversationEvent = await FirebaseDatabase.instance
          .ref('chats/$conversationId')
          .once();

      // Create conversation if it doesn't exist
      if (conversationEvent.snapshot.value == null) {
        await FirebaseDatabase.instance
            .ref('chats/$conversationId')
            .set({
          'product_id': product.id,
          'product_name': product.title,
          'participants': {
            user.uid: true,
            sellerId: true,
          },
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'last_message': '',
          'last_message_time': DateTime.now().millisecondsSinceEpoch,
        });
      }

      // Open chat
      Get.to(() => ChatScreen(
        conversationId: conversationId,
        productId: product.id,
        productName: product.title,
        otherUserId: sellerId,
        otherUserName: sellerName,
        otherUserAvatar: sellerAvatar,
      ));
    } catch (e) {
      print('❌ Error contacting seller: $e');
      Get.snackbar('Error', 'Failed to open chat');
    }
  }

  void buyNow() {
    Get.to(() => PurchaseFormScreen(product: product));
  }

  void searchDetails() {
    Get.snackbar('Search', 'Searching product details on Google');
  }
}

