import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/my_account_controller.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/payment_screen/payment_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/utils/responsive.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';
import 'package:rebuyproject/widgets/universal_image.dart';

class PurchaseFormScreen extends StatelessWidget {
  final Product product;

  const PurchaseFormScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Put or Find the controller to access user profile data
    final accountController = Get.put(MyAccountController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsivePadding.pageHorizontal,
            vertical: ResponsivePadding.pageVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

              // Progress Indicator
              _buildProgressIndicator(currentStep: 1),
              SizedBox(height: ResponsiveGap.xl),

              // Product Details Card
              Container(
                padding: EdgeInsets.all(4.wp),
                decoration: BoxDecoration(
                  color: Color(0xffB8D8D8),
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
                              fontWeight: FontWeight.w500,
                              color: Color(0xff3C3C3C),
                            ),
                          ),
                          Text(
                            'Make: ${product.make} | Year: ${product.year}',
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.xs,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 0.5.hp),
                          Text(
                            product.price,
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.lg,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3C3C3C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Shipping Address
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.wp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveBorderRadius.medium,
                  ),
                  border: Border.all(color: Color(0xffE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping address',
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.lg,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3C3C3C),
                      ),
                    ),
                    // Use Obx to update when user data is fetched
                    Obx(() {
                      // Check if data is loaded (optional, depending on logic)
                      // If name/address are empty, show placeholders or "Not set"
                      final name =
                          accountController.name.value.isNotEmpty
                          ? accountController.name.value
                          : 'Name not set';
                      final address =
                          accountController.address.value.isNotEmpty
                          ? accountController.address.value
                          : 'Address not set';
                      final phone =
                          accountController.phone.value.isNotEmpty
                          ? accountController.phone.value
                          : 'Phone not set';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.sm,
                              color: Color(0xff3C3C3C),
                            ),
                          ),
                          Text(
                            address,
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.sm,
                              color: Color(0xff3C3C3C),
                            ),
                          ),
                          Text(
                            'Ph: $phone',
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.sm,
                              color: Color(0xff3C3C3C),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Invoice Details
              Container(
                padding: EdgeInsets.all(4.wp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveBorderRadius.medium,
                  ),
                  border: Border.all(color: Color(0xffE0E0E0)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Invoice details',
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.lg,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3C3C3C),
                      ),
                    ),
                    SizedBox(height: ResponsiveGap.md),
                    _buildInvoiceRow('Product cost:', product.price),
                    SizedBox(height: ResponsiveGap.sm),
                    _buildInvoiceRow('Shipping fee:', '₹ 150'),
                    SizedBox(height: ResponsiveGap.sm),
                    Divider(),
                    _buildInvoiceRow(
                      'Total:',
                      _calculateTotal(product.price),
                      isBold: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveGap.xxl),

              // Proceed Button
            ],
          ),
        ),

        bottomNavigationBar: Container(
          width: double.infinity,
          height: ResponsiveButtonSize.height,
          decoration: BoxDecoration(color: Color(0xffFF5A5F)),
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => PaymentScreen(product: product));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveBorderRadius.small,
                ),
              ),
            ),
            child: Text(
              'Proceed to Payment',
              style: TextStyle(
                fontSize: ResponsiveFontSize.xl,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator({required int currentStep}) {
    return Row(
      children: [
        _buildProgressDot(
          isActive: currentStep >= 1,
          isFilled: currentStep > 1,
        ),
        Expanded(child: _buildProgressLine(isActive: currentStep > 1)),
        _buildProgressDot(
          isActive: currentStep >= 2,
          isFilled: currentStep > 2,
        ),
        Expanded(child: _buildProgressLine(isActive: currentStep > 2)),
        _buildProgressDot(
          isActive: currentStep >= 3,
          isFilled: currentStep > 3,
        ),
      ],
    );
  }

  Widget _buildProgressDot({required bool isActive, required bool isFilled}) {
    return Container(
      width: 5.wp,
      height: 2.5.hp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? Color(0xffE57373) : Colors.white,
        border: Border.all(
          color: isActive ? Color(0xffE57373) : Color(0xffE0E0E0),
          width: 0.75.wp,
        ),
      ),
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Container(
      height: 0.5.hp,
      color: isActive ? Color(0xffE57373) : Color(0xffE0E0E0),
    );
  }

  Widget _buildInvoiceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveFontSize.sm,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Color(0xff3C3C3C),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveFontSize.sm,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Color(0xff3C3C3C),
          ),
        ),
      ],
    );
  }

  String _calculateTotal(String price) {
    // Extract number from price string (e.g., "₹ 24,999")
    final priceValue =
        int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final total = priceValue + 150;
    return '₹ ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
