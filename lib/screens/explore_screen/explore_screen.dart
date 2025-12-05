import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/explore_controller.dart';
import 'package:rebuyproject/controllers/home_controller.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/product_details_screen/product_details_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/widgets/custom_bottom_nav_bar.dart';
import 'package:rebuyproject/widgets/universal_image.dart';
import 'package:rebuyproject/utils/responsive.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';
import 'package:rebuyproject/screens/home_screen/widgets/app_drawer.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExploreController());
    final homeController = Get.find<HomeController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(controller: homeController),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.pageHorizontal,
                vertical: ResponsivePadding.pageVertical,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff555555)),
                      borderRadius: BorderRadius.circular(
                        ResponsiveBorderRadius.medium,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: ResponsiveIconSize.small,
                      ),
                      onPressed: () =>
                          homeController.onBottomNavTapped(0), // Go to home
                    ),
                  ),
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: ResponsiveFontSize.xxxl,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: ResponsiveIconSize.large,
                      color: AppColors.textDark,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.pageHorizontal,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffDEDEDE),
                  borderRadius: BorderRadius.circular(
                    ResponsiveBorderRadius.large,
                  ),
                ),
                child: Obx(() {
                  return TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for books, guitar and more...',
                      hintStyle: TextStyle(
                        color: Color(0xff828282),
                        fontSize: ResponsiveFontSize.sm,
                      ),
                      suffixIcon: controller.isSearching.value
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Color(0xff999999)),
                              onPressed: controller.clearSearch,
                            )
                          : Icon(Icons.search, color: Color(0xff999999)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 6.25.wp,
                        vertical: 1.75.hp,
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: ResponsiveGap.xl),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.pageHorizontal,
              ),
              child: Obx(
                () => Row(
                  children: controller.categories.map((category) {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: EdgeInsets.only(right: 3.wp),
                      child: ChoiceChip(
                        checkmarkColor: Colors.white,
                        color: WidgetStatePropertyAll(AppColors.textDark),
                        label: Text(
                          category,
                          style: TextStyle(
                            color: Color(0xffE2E2E2),
                            fontSize: ResponsiveFontSize.sm,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) =>
                            controller.onCategorySelected(category),
                        selectedColor: Colors.grey.withOpacity(0.1),
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveFontSize.sm,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveBorderRadius.medium,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.transparent,
                          ), // Remove border
                        ),
                      ), //
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: ResponsiveGap.lg),

            // Search Results Header (if searching)
            Obx(() {
              if (controller.isSearching.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsivePadding.pageHorizontal,
                    vertical: 1.hp,
                  ),
                  child: Text(
                    'Search Results (${controller.searchResults.length})',
                    style: TextStyle(
                      fontSize: ResponsiveFontSize.md,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
            SizedBox(height: ResponsiveGap.sm),

            // Product Feed
            Expanded(
              child: Obx(() {
                // Determine which products to show
                final products = controller.isSearching.value
                    ? controller.searchResults
                    : controller.exploreProducts;

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      controller.isSearching.value
                          ? 'No products found'
                          : 'No products yet',
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.md,
                        color: Color(0xff979797),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(6.wp, 0, 6.wp, 12.5.hp),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildFeedCard(products[index], controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedCard(Product product, ExploreController controller) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(3.wp),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 5.wp,
                    backgroundImage: NetworkImage(product.sellerAvatar),
                  ),
                  SizedBox(width: 3.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.sellerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                            fontSize: ResponsiveFontSize.sm,
                          ),
                        ),
                        Text(
                          product.sellerLocation,
                          style: TextStyle(
                            fontSize: ResponsiveFontSize.xs,
                            color: Color(0xff747474),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Color(0xff3C3C3C),
                    size: ResponsiveIconSize.medium,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 3.hp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveBorderRadius.medium,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header

                  // Image
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.1),
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 37.5.hp,
                            width: 50.wp,
                            child: UniversalImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2.hp,
                        right: 4.wp,
                        child: GestureDetector(
                          onTap: () => controller.toggleFavorite(product),
                          child: Container(
                            padding: EdgeInsets.all(2.wp),
                            decoration: BoxDecoration(
                              color: Color(
                                0xffFF5858,
                              ).withOpacity(0.2), // Red/Pink
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Color(0xffFF5858),
                              size: ResponsiveIconSize.medium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Details
                  Padding(
                    padding: EdgeInsets.all(4.wp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: ResponsiveFontSize.lg,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 0.5.hp),
                            Text(
                              'Make: ${product.make} | Year: ${product.year}',
                              style: TextStyle(
                                fontSize: ResponsiveFontSize.xs,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          product.price,
                          style: TextStyle(
                            fontSize: ResponsiveFontSize.lg,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
