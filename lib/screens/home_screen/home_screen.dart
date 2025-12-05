import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/home_controller.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/home_screen/widgets/app_drawer.dart';
import 'package:rebuyproject/screens/liked_items_screen/liked_items_screen.dart';
import 'package:rebuyproject/screens/product_details_screen/product_details_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/widgets/universal_image.dart';
import 'package:rebuyproject/utils/responsive.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      // Custom Bottom Navigation Bar
      extendBody: true, // Allows body to go behind the bottom bar if needed
      bottomNavigationBar: _buildBottomNavigationBar(controller),
      body: SafeArea(
        bottom: false, //
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 12.5.hp), // Space for bottom bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveGap.lg),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsivePadding.pageHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(1.5.wp),

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff3C3C3C),
                              width: 1.wp,
                            ),

                            shape: BoxShape.circle,
                          ),
                          child: Obx(() {
                            return CircleAvatar(
                              radius: ResponsiveCardSize.avatarRadius,
                              backgroundImage:
                                  controller.userProfileImage.value != null
                                  ? UniversalImageProvider(
                                      controller.userProfileImage.value!,
                                    )
                                  : const NetworkImage(
                                          'https://i.pravatar.cc/150?u=alice',
                                        )
                                        as ImageProvider,
                            );
                          }),
                        ),
                        SizedBox(width: 3.wp),
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey ${controller.userName.value}',
                                style: TextStyle(
                                  fontSize: ResponsiveFontSize.xxxl,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3C3C3C),
                                ),
                              ),
                              Text(
                                'Welcome back!',
                                style: TextStyle(
                                  fontSize: ResponsiveFontSize.md,
                                  color: Color(0xffFF5A5F),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: ResponsiveIconSize.large,
                        color: Color(0xff3C3C3C),
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsivePadding.pageHorizontal,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(
                      ResponsiveBorderRadius.large,
                    ),
                  ),
                  child: Obx(() {
                    return TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        fillColor: Color(0xffDEDEDE),
                        hintText: 'Search for books, guitar and more...',
                        hintStyle: TextStyle(
                          color: Color(0xff828282),
                          fontSize: ResponsiveFontSize.sm,
                        ),
                        suffixIcon: controller.isSearching.value
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Color(0xff999999),
                                ),
                                onPressed: controller.clearSearch,
                              )
                            : Icon(Icons.search, color: Color(0xff999999)),
                        prefixIconConstraints: BoxConstraints(minWidth: 4.wp),
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
              SizedBox(height: ResponsiveGap.xxl),

              // Search Results or Normal Sections
              Obx(() {
                if (controller.isSearching.value) {
                  // Show search results
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsivePadding.pageHorizontal,
                        ),
                        child: Text(
                          'Search Results (${controller.searchResults.length})',
                          style: TextStyle(
                            fontSize: ResponsiveFontSize.xxl,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff3C3C3C),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveGap.lg),
                      if (controller.searchResults.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(
                            ResponsivePadding.pageHorizontal,
                          ),
                          child: Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: ResponsiveFontSize.md,
                                color: Color(0xff979797),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: ResponsiveCardSize.productCardHeight,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsivePadding.pageHorizontal,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(
                                controller.searchResults[index],
                                controller,
                              );
                            },
                          ),
                        ),
                    ],
                  );
                } else {
                  // Show normal sections (New Arrivals & Recently Viewed)
                  return Column(
                    children: [
                      // New Arrivals
                      _buildSectionHeader(
                        title: 'New arrivals',
                        onViewMore: () {},
                      ),
                      SizedBox(height: ResponsiveGap.lg),
                      Obx(() {
                        if (controller.newArrivals.isEmpty) {
                          return SizedBox(
                            height: ResponsiveCardSize.productCardHeight,
                            child: Center(
                              child: Text(
                                'No products yet',
                                style: TextStyle(
                                  fontSize: ResponsiveFontSize.md,
                                  color: Color(0xff979797),
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: ResponsiveCardSize.productCardHeight,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsivePadding.pageHorizontal,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.newArrivals.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(
                                controller.newArrivals[index],
                                controller,
                              );
                            },
                          ),
                        );
                      }),

                      SizedBox(height: ResponsiveGap.xl),

                      // Recently Viewed
                      _buildSectionHeader(
                        title: 'Recently viewed',
                        onViewMore: () {},
                      ),
                      SizedBox(height: ResponsiveGap.lg),
                      Obx(() {
                        if (controller.recentlyViewed.isEmpty) {
                          return SizedBox(
                            height: ResponsiveCardSize.productCardHeight,
                            child: Center(
                              child: Text(
                                'No products yet',
                                style: TextStyle(
                                  fontSize: ResponsiveFontSize.md,
                                  color: Color(0xff979797),
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: ResponsiveCardSize.productCardHeight,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsivePadding.pageHorizontal,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.recentlyViewed.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(
                                controller.recentlyViewed[index],
                                controller,
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewMore,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsivePadding.pageHorizontal,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveFontSize.xxl,
              fontWeight: FontWeight.w700,
              color: Color(0xff3C3C3C),
            ),
          ),
          GestureDetector(
            onTap: onViewMore,
            child: Text(
              'View more',
              style: TextStyle(
                fontSize: ResponsiveFontSize.sm,
                color: Color(0xff898989),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, HomeController controller) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailsScreen(product: product));
      },
      child: Container(
        width: ResponsiveCardSize.productCardWidth,
        margin: EdgeInsets.only(right: 5.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveBorderRadius.medium),
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
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(ResponsiveBorderRadius.medium),
                      ),
                      image: DecorationImage(
                        image: UniversalImageProvider(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.hp,
                    right: 2.wp,
                    child: GestureDetector(
                      onTap: () => controller.toggleFavorite(product),
                      child: Container(
                        padding: EdgeInsets.all(1.5.wp),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: ResponsiveIconSize.medium,
                          color: Color(0xffFF5858),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.wp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveFontSize.lg,
                            color: Color(0xff3C3C3C),
                          ),
                        ),
                        SizedBox(height: 0.5.hp),
                        Text(
                          product.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveFontSize.sm,
                            color: Color(0xffC1839F),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveFontSize.lg,
                        color: Color(0xff3C3C3C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(HomeController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(6.wp, 0, 6.wp, 3.hp),
      height: 8.75.hp,
      decoration: BoxDecoration(
        color: AppColors.textDark, // Dark grey/black background
        borderRadius: BorderRadius.circular(8.75.wp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_filled,
              index: 0,
              controller: controller,
              isActive: true,
            ),
            _buildNavItem(
              icon: Icons.explore_outlined,
              index: 1,
              controller: controller,
            ),
            _buildCenterNavItem(controller: controller),
            _buildNavItem(
              icon: Icons.favorite_border,
              index: 3,
              controller: controller,
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              index: 4,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required HomeController controller,
    bool isActive = false,
  }) {
    final isSelected = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          Get.to(() => const LikedItemsScreen());
          controller.onBottomNavTapped(index);
        } else {
          controller.onBottomNavTapped(index);
        }
      },
      child: Container(
        width: 10.wp,
        height: 5.hp,
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF36898B), // Teal color from screenshot
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey.shade400,
          size: ResponsiveIconSize.medium,
        ),
      ),
    );
  }

  Widget _buildCenterNavItem({required HomeController controller}) {
    return GestureDetector(
      onTap: () {
        // Camera/Sell action
      },
      child: Container(
        width: 12.5.wp,
        height: 6.25.hp,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          color: AppColors.textDark,
          size: ResponsiveIconSize.large,
        ),
      ),
    );
  }
}
