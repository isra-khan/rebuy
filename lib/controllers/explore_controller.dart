import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';

class ExploreController extends GetxController {
  final RxString selectedCategory = 'All'.obs;

  final List<String> categories = ['All', 'Books', 'Game', 'Music', 'Camera'];

  final exploreProducts = <Product>[].obs;
  final allProducts = <Product>[].obs;
  final searchResults = <Product>[].obs;
  final searchController = TextEditingController();
  final isSearching = false.obs;

  @override
  void onInit() {
 
    _loadDefaultProducts();
    fetchProducts();
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

  void searchProducts(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    // Search in products based on selected category
    final productsToSearch = selectedCategory.value == 'All'
        ? allProducts
        : allProducts
              .where(
                (p) =>
                    p.title.toLowerCase().contains(
                      selectedCategory.value.toLowerCase(),
                    ) ||
                    p.subtitle.toLowerCase().contains(
                      selectedCategory.value.toLowerCase(),
                    ),
              )
              .toList();

    final results = productsToSearch.where((product) {
      return product.title.toLowerCase().contains(query) ||
          product.subtitle.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.make.toLowerCase().contains(query) ||
          product.price.toLowerCase().contains(query);
    }).toList();

    searchResults.assignAll(results);
    print('🔍 Explore search for "$query" found ${results.length} results');
  }

  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    searchResults.clear();
  }

  Future<void> fetchProducts() async {
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
        
        if (products.isNotEmpty) {
          allProducts.assignAll(products);
          filterByCategory();
         
        }
      } else {
     
      }
    } catch (e) {
     
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
    filterByCategory();
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    filterByCategory();
    // If searching, re-run search with new category filter
    if (isSearching.value) {
      searchProducts(searchController.text.trim().toLowerCase());
    }
  }

  void filterByCategory() {
    if (selectedCategory.value == 'All') {
      exploreProducts.assignAll(allProducts);
    } else {
      final filtered = allProducts.where((product) {
        return product.title.toLowerCase().contains(
              selectedCategory.value.toLowerCase(),
            ) ||
            product.subtitle.toLowerCase().contains(
              selectedCategory.value.toLowerCase(),
            );
      }).toList();
      exploreProducts.assignAll(filtered);
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
        // Remove from favorites
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
        // Add to favorites
        await FirebaseDatabase.instance.ref('favorites').push().set({
          'user_id': user.uid,
          'product_id': product.id,
        });
      }

      // Update UI for all product lists
      final updatedProduct = product.copyWith(isFavorite: !isFavorite);

      // Update in allProducts
      final allIndex = allProducts.indexWhere((p) => p.id == product.id);
      if (allIndex != -1) {
        allProducts[allIndex] = updatedProduct;
      }

      // Update in exploreProducts
      final exploreIndex = exploreProducts.indexWhere(
        (p) => p.id == product.id,
      );
      if (exploreIndex != -1) {
        exploreProducts[exploreIndex] = updatedProduct;
      }

      // Update in searchResults
      final searchIndex = searchResults.indexWhere((p) => p.id == product.id);
      if (searchIndex != -1) {
        searchResults[searchIndex] = updatedProduct;
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
