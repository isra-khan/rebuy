import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/explore_screen/explore_screen.dart';
import 'package:rebuyproject/screens/home_screen/home_screen.dart';
import 'package:rebuyproject/screens/liked_items_screen/liked_items_screen.dart';
import 'package:rebuyproject/screens/messages_screen/messages_screen.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final newArrivals = <Product>[].obs;
  final recentlyViewed = <Product>[].obs;
  final searchResults = <Product>[].obs;
  final userName = Rx<String>('Alice'); // Default placeholder
  final userProfileImage = Rx<String?>(null);
  final searchController = TextEditingController();
  final isSearching = false.obs;
  final allProducts = <Product>[].obs;

  @override
  void onInit() {
    // Load default products first for immediate display
    _loadDefaultProducts();
    fetchUserProfile();
    fetchNewArrivals();
    fetchRecentlyViewed();
    searchController.addListener(_onSearchChanged);
    super.onInit();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
    } else {
      isSearching.value = true;
      searchProducts(query);
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

   
    final results = allProducts.where((product) {
      return product.title.toLowerCase().contains(query) ||
          product.subtitle.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.make.toLowerCase().contains(query) ||
          product.price.toLowerCase().contains(query);
    }).toList();

    searchResults.value = results;
  }

  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    searchResults.clear();
  }

  Future<void> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Set default if display name is available
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      userName.value = user.displayName!;
    }

    try {
      final event = await FirebaseDatabase.instance
          .ref('users/${user.uid}')
          .once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        if (data['name'] != null) userName.value = data['name'];
        if (data['profile_image'] != null)
          userProfileImage.value = data['profile_image'];
      }
    } catch (e) {
      // Use defaults if fetch fails
    }
  }

  Future<void> fetchNewArrivals() async {
    try {
      // Fetch from 'products' table only
      final event = await FirebaseDatabase.instance.ref('products').once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        List<Product> products = [];

        for (var e in data.entries) {
          final productData = Map<String, dynamic>.from(e.value as Map);
          productData['id'] = e.key;
          final product = Product.fromJson(productData);

          // Check if this product is favorited
          final isFav = await isProductFavorite(product);
          products.add(product.copyWith(isFavorite: isFav));
        }

        // Only update if we have products from Firebase
        if (products.isNotEmpty) {
          // Store all products for search
          allProducts.assignAll(products);

          // Shuffle to show random products
          products.shuffle();

          newArrivals.assignAll(products);
          print('✅ Fetched ${products.length} products from products table');
        }
      } else {
        print('⚠️ Products table is empty, showing default products');
      }
    } catch (e) {
      print('❌ Error fetching products: $e, showing defaults');
    }
  }

  void _loadDefaultProducts() {
    final defaultProducts = [
      Product(
        id: 'default_1',
        title: 'Batman Toy',
        subtitle: 'Lego Batman Car',
        price: '₹ 899',
        imageUrl:
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=800',
        description:
            'LEGO Batman toy car with removable minifigure. Great condition, all pieces included.',
        make: 'LEGO',
        year: '2018',
        hasWarranty: false,
        hasOriginalPacking: true,
      ),
      Product(
        id: 'default_2',
        title: 'You Are Young Book',
        subtitle: 'Motivational Novel',
        price: '₹ 299',
        imageUrl:
            'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800',
        description:
            'Inspiring book about youth and motivation. Minimal wear, great read.',
        make: 'H&C',
        year: '2020',
        hasWarranty: false,
        hasOriginalPacking: false,
      ),
      Product(
        id: 'default_3',
        title: 'iPad Tablet',
        subtitle: 'Apple iPad 9th Gen',
        price: '₹ 24,999',
        imageUrl:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800',
        description:
            'iPad 9th generation, 64GB, WiFi model. Excellent condition with minimal scratches.',
        make: 'Apple',
        year: '2021',
        hasWarranty: true,
        hasOriginalPacking: true,
      ),
      Product(
        id: 'default_4',
        title: 'Coffee Mug Set',
        subtitle: 'Ceramic Mugs (2pcs)',
        price: '₹ 399',
        imageUrl:
            'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=800',
        description:
            'Beautiful ceramic coffee mugs, set of 2. Perfect for your morning coffee.',
        make: 'HomeDecor',
        year: '2023',
        hasWarranty: false,
        hasOriginalPacking: true,
      ),
      Product(
        id: 'default_5',
        title: 'Acoustic Guitar',
        subtitle: 'Yamaha F280',
        price: '₹ 8,500',
        imageUrl:
            'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=800',
        description:
            'Yamaha acoustic guitar in excellent condition. Comes with carry bag and picks.',
        make: 'Yamaha',
        year: '2019',
        hasWarranty: false,
        hasOriginalPacking: false,
      ),
    ];

    allProducts.assignAll(defaultProducts);
    newArrivals.assignAll(defaultProducts);

 
    final shuffledProducts = List<Product>.from(defaultProducts)..shuffle();
    recentlyViewed.assignAll(shuffledProducts);
  }

  Future<void> fetchRecentlyViewed() async {
    try {
  
      final event = await FirebaseDatabase.instance.ref('products').once();

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        List<Product> products = [];

        for (var e in data.entries) {
          final productData = Map<String, dynamic>.from(e.value as Map);
          productData['id'] = e.key;
          final product = Product.fromJson(productData);

          // Check if this product is favorited
          final isFav = await isProductFavorite(product);
          products.add(product.copyWith(isFavorite: isFav));
        }

       
        if (products.isNotEmpty) {

          products.shuffle();
          recentlyViewed.assignAll(products);

        }
      } else {
       
      }
    } catch (e) {

    }
  }

  void onBottomNavTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offAll(() => HomeScreen());
        break;
      case 1:
        Get.to(() => const ExploreScreen());
        break;
      case 2:
       
        Get.snackbar('Camera', 'Open Camera/Sell');
        break;
      case 3:
        Get.to(() => const LikedItemsScreen());
        break;
      case 4:
        Get.to(() => const MessagesScreen());
        break;
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'You must be logged in to like a product');
        return;
      }

      final isFavorite = await isProductFavorite(product);

      if (isFavorite) {
        final event = await FirebaseDatabase.instance
            .ref('favorites')
            .orderByChild('user_id')
            .equalTo(user.uid)
            .once();

        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          // Collect keys to delete first to avoid ConcurrentModificationException
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
      } else {
        await FirebaseDatabase.instance.ref('favorites').push().set({
          'user_id': user.uid,
          'product_id': product.id,
        });
      }

      // Update the UI
      final index = newArrivals.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        newArrivals[index] = product.copyWith(isFavorite: !isFavorite);
      }
      final recentlyViewedIndex = recentlyViewed.indexWhere(
        (p) => p.id == product.id,
      );
      if (recentlyViewedIndex != -1) {
        recentlyViewed[recentlyViewedIndex] = product.copyWith(
          isFavorite: !isFavorite,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> isProductFavorite(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final event = await FirebaseDatabase.instance
        .ref('favorites')
        .orderByChild('user_id')
        .equalTo(user.uid)
        .once();

    if (event.snapshot.value != null) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      for (var entry in data.values) {
        if (entry['product_id'] == product.id) {
          return true;
        }
      }
    }

    return false;
  }
}
