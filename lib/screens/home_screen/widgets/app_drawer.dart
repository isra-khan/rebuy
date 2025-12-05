import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/screens/add_listing_screen/add_listing_screen.dart';
import 'package:rebuyproject/screens/liked_items_screen/liked_items_screen.dart';
import 'package:rebuyproject/screens/login_screen/login_screen.dart';
import 'package:rebuyproject/screens/my_account_screen/my_account_screen.dart';
import 'package:rebuyproject/screens/my_listings_screen/my_listings_screen.dart';
import 'package:rebuyproject/screens/my_orders_screen/my_orders_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F5F5),
      surfaceTintColor: Colors.transparent,
      width:
          MediaQuery.of(context).size.width *
          0.85, // Make it wide like in design
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ReBuy',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 60,
                            color: AppColors.textDark,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Menu Items
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'My Account',
                      subtitle: 'Edit you details, account settings',
                      onTap: () {
                        Get.back(); // Close drawer
                        Get.to(() => MyAccountScreen());
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      subtitle: 'View all your orders',
                      onTap: () {
                        Get.back(); // Close drawer
                        Get.to(() => const MyOrdersScreen());
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Add Listing',
                      subtitle: 'View all your orders',
                      onTap: () {
                        Get.back(); // Close drawer
                        Get.to(() => const AddListingScreen());
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.list_alt,
                      title: 'My Listings',
                      subtitle: 'View your product listing for sale',
                      onTap: () {
                        Get.back(); // Close drawer
                        Get.to(() => const MyListingsScreen());
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Liked Items',
                      subtitle: 'See the products you have wishlisted',
                      onTap: () {
                        Get.back(); // Close drawer
                        Get.to(() => const LikedItemsScreen());
                      },
                    ),

                    const SizedBox(height: 16),

                    // Bottom Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: const BorderSide(color: AppColors.textDark),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Feedback',
                              style: TextStyle(
                                color: Color(0xff3C3C3C),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.offAll(() => const LoginScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff3C3C3C),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign out',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Wave Footer
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 80),
                  painter: WavePainter(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'ReBuy Inc. Version 1.0',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFDEE8EB), // Light grey/blueish background
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF555555)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFf5F5F5F),
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

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFE57373)
          .withOpacity(0.6) // Lighter red
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color =
          const Color(0xFFEF5350) // Darker red
      ..style = PaintingStyle.fill;

    // Back wave
    final path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, size.height * 0.5);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.6,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 1.0,
      size.width,
      size.height * 0.5,
    );
    path1.lineTo(size.width, size.height);
    path1.close();

    // Front wave
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.85,
      size.width * 0.6,
      size.height * 0.4,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.1,
      size.width,
      size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
