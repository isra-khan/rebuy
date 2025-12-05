import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/product_details_controller.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/widgets/universal_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ProductDetailsController(product),
      tag: product.id,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff555555)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Spacer(),
                  const Text(
                    'ReBuy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance spacing
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    SizedBox(
                      height: 300,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemCount: 3, // Dummy count
                            onPageChanged: controller.onPageChanged,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: UniversalImage(
                                    imageUrl: product.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.currentImageIndex.value ==
                                              index
                                          ? Colors.black
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Product Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.contactSeller,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF5350), // Pinkish Red
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.price,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF36898B), // Teal
                            ),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              text: product.description,
                              style: const TextStyle(
                                color: Color(0xff666666),

                                fontSize: 14,
                                height: 1.5,
                              ),
                              children: const [
                                TextSpan(
                                  text: ' more...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Details Table
                          Row(
                            children: [
                              Text(
                                'Make: ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                product.make,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '| ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                'Year: ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                product.year,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Within Warranty ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Icon(
                                product.hasWarranty ? Icons.check : Icons.close,
                                color: product.hasWarranty
                                    ? Colors.green
                                    : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Original Packing ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Icon(
                                product.hasOriginalPacking
                                    ? Icons.check
                                    : Icons.close,
                                color: product.hasOriginalPacking
                                    ? Colors.green
                                    : Colors.red,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Search Details Button
                          Container(
                            width: 200,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.textDark),
                            ),
                            child: TextButton.icon(
                              onPressed: controller.searchDetails,
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            
                              label: const Text(
                                'Search Details',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Similar Products
                          const Text(
                            'Similar products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120, // Small list
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // Dummy
                        itemBuilder: (context, index) {
                          // Using dummy images for similar products based on design showing partially visible items
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      onPressed: controller.contactSeller,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF36898B), // Teal
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Contact Seller',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      onPressed: controller.buyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5350), // Pinkish Red
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
