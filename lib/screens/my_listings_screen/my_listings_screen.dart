import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/home_controller.dart';
import 'package:rebuyproject/controllers/my_listings_controller.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/home_screen/home_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/widgets/universal_image.dart';
import 'package:rebuyproject/screens/home_screen/widgets/app_drawer.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyListingsController());

    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      extendBody: true,
      bottomNavigationBar: _buildBottomNavigationBar(homeController),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // Header
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
                    const Text(
                      'My Listings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
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
              const SizedBox(height: 16),

              // List
              Obx(() {
                if (controller.myListings.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: Text("No listings found")),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: controller.myListings.length,
                  itemBuilder: (context, index) {
                    return _buildListingCard(controller.myListings[index]);
                  },
                );
              }),
              const SizedBox(height: 24),

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPageButton(icon: Icons.arrow_back_ios_new),
                  const SizedBox(width: 8),
                  _buildPageNumber('1', isSelected: true),
                  const SizedBox(width: 8),
                  _buildPageNumber('2'),
                  const SizedBox(width: 8),
                  _buildPageButton(icon: Icons.arrow_forward_ios),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListingCard(Product product) {
    Color backgroundColor;
    if (product.listingStatus == ListingStatus.hidden) {
      backgroundColor = Colors.grey.shade300;
    } else if (product.listingStatus == ListingStatus.sold) {
      backgroundColor = const Color(0xFFD8E6D6); // Light Greenish
    } else {
      backgroundColor = const Color(0xFFDEE8EB); // Light Blueish
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              image: DecorationImage(
                image: UniversalImageProvider(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Views: ${product.views}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (product.listingStatus == ListingStatus.active &&
                        product.messageCount > 0) ...[
                      const Icon(
                        Icons.mail_outline,
                        size: 14,
                        color: Color(0xFF555555),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.messageCount}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ] else if (product.listingStatus ==
                        ListingStatus.hidden) ...[
                      const Text(
                        'Hidden',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ] else if (product.listingStatus == ListingStatus.sold) ...[
                      const Text(
                        'Sold',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF36898B), // Teal
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        product.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEF9A9A), // Light red text date
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Icon
          if (product.listingStatus == ListingStatus.active)
            const Icon(Icons.visibility_off_outlined, color: Color(0xFF555555))
          else if (product.listingStatus == ListingStatus.hidden)
            const Icon(Icons.visibility_outlined, color: Color(0xFF555555))
          else if (product.listingStatus == ListingStatus.sold)
            const Icon(Icons.check_circle, color: Colors.green, size: 28),
        ],
      ),
    );
  }

  Widget _buildPageNumber(String number, {bool isSelected = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.grey.shade300 : Colors.transparent,
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton({required IconData icon}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Icon(icon, size: 12, color: AppColors.textDark)),
    );
  }

  Widget _buildBottomNavigationBar(HomeController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.textDark,
        borderRadius: BorderRadius.circular(35),
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
  }) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Get.offAll(() => HomeScreen());
          controller.onBottomNavTapped(0);
        } else {
          controller.onBottomNavTapped(index);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: isSelected
            ? const BoxDecoration(
                color: Color(0xFF36898B),
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey.shade400,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCenterNavItem({required HomeController controller}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: AppColors.textDark,
          size: 28,
        ),
      ),
    );
  }
}
