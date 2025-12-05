import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/home_screen/home_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/utils/responsive.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';
import 'package:rebuyproject/widgets/universal_image.dart';
import 'dart:math';

class OrderConfirmationScreen extends StatelessWidget {
  final Product product;

  const OrderConfirmationScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final trackingId = _generateTrackingId();
    final orderId = _generateOrderId();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsivePadding.pageHorizontal,
            vertical: ResponsivePadding.pageVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
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
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Text(
                    'ReBuy',
                    style: TextStyle(
                      fontSize: ResponsiveFontSize.heading,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                  SizedBox(width: 12.wp), // Empty space for alignment
                ],
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Order confirmation',
                  style: TextStyle(
                    fontSize: ResponsiveFontSize.xxl,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff979797),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Progress Indicator
              _buildProgressIndicator(),
              SizedBox(height: ResponsiveGap.xxl),

              // Order Confirmed Text
              Text(
                'Order Confirmed',
                style: TextStyle(
                  fontSize: ResponsiveFontSize.xxxl,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C3C3C),
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Success Icon
              Container(
                width: 25.wp,
                height: 12.5.hp,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: ResponsiveIconSize.xlarge * 2,
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Success Message
              Text(
                'Your payment for',
                style: TextStyle(
                  fontSize: ResponsiveFontSize.lg,
                  color: Color(0xff3C3C3C),
                ),
              ),
              Text(
                _calculateTotal(product.price),
                style: TextStyle(
                  fontSize: ResponsiveFontSize.xxxl,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C3C3C),
                ),
              ),
              Text(
                'is successfull',
                style: TextStyle(
                  fontSize: ResponsiveFontSize.lg,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C3C3C),
                ),
              ),
              SizedBox(height: ResponsiveGap.xxl),

              // Product Details Card
              Container(
                padding: EdgeInsets.all(4.wp),
                decoration: BoxDecoration(
                  color: Color(0xffB8D8C8),
                  borderRadius: BorderRadius.circular(
                    ResponsiveBorderRadius.medium,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20.wp,
                      height: 10.hp,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveBorderRadius.small,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveBorderRadius.small,
                        ),
                        child: UniversalImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.md,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff3C3C3C),
                            ),
                          ),
                          SizedBox(height: 0.5.hp),
                          Text(
                            'Tracking ID: $trackingId',
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.xs,
                              color: Color(0xff555555),
                            ),
                          ),
                          Text(
                            'Order ID: $orderId',
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.xs,
                              color: Color(0xff555555),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveGap.xxl * 2),

              // Go to Home Button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: ResponsiveButtonSize.height,
        decoration: BoxDecoration(color: Color(0xffFF5A5F)),
        child: ElevatedButton(
          onPressed: () {
            Get.offAll(() => HomeScreen());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveBorderRadius.small),
            ),
          ),
          child: Text(
            'Go to home',
            style: TextStyle(
              fontSize: ResponsiveFontSize.lg,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressDot(isFilled: true),
        Expanded(child: _buildProgressLine()),
        _buildProgressDot(isFilled: true),
        Expanded(child: _buildProgressLine()),
        _buildProgressDot(isFilled: true),
      ],
    );
  }

  Widget _buildProgressDot({required bool isFilled}) {
    return Container(
      width: 5.wp,
      height: 2.5.hp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffE57373),
        border: Border.all(color: Color(0xffE57373), width: 0.75.wp),
      ),
    );
  }

  Widget _buildProgressLine() {
    return Container(height: 0.5.hp, color: Color(0xffE57373));
  }

  String _calculateTotal(String price) {
    final priceValue =
        int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final total = priceValue + 150;
    return '₹ ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String _generateTrackingId() {
    final random = Random();
    return random.nextInt(900000000).toString() +
        random.nextInt(9999).toString();
  }

  String _generateOrderId() {
    final random = Random();
    // Combine smaller random numbers to create a long Order ID safely
    return '${random.nextInt(999999)}${random.nextInt(999999)}${random.nextInt(9999)}';
  }
}
