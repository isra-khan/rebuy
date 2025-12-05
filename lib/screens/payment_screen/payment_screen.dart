import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/my_account_controller.dart';
import 'package:rebuyproject/models/product.dart';
import 'package:rebuyproject/screens/order_confirmation_screen/order_confirmation_screen.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/utils/responsive.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;

  const PaymentScreen({super.key, required this.product});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedCardIndex = 0;
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountController = Get.put(MyAccountController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
              _buildProgressIndicator(currentStep: 2),
              SizedBox(height: ResponsiveGap.xl),

              // Product Name
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
                      widget.product.title,
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.lg,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff3C3C3C),
                      ),
                    ),

                    Text(
                      'Make: ${widget.product.make} | Year: ${widget.product.year}',
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.xs,
                        color: Color(0xff555555),
                      ),
                    ),
                    SizedBox(height: ResponsiveGap.xl),

                    // Payment Details
                    Text(
                      'Payment details',
                      style: TextStyle(
                        fontSize: ResponsiveFontSize.lg,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3C3C3C),
                      ),
                    ),
                    SizedBox(height: ResponsiveGap.md),
                    _buildPaymentRow('Product cost:', widget.product.price),
                    SizedBox(height: ResponsiveGap.sm),
                    _buildPaymentRow('Shipping fee:', '₹ 150'),
                    SizedBox(height: ResponsiveGap.sm),
                    Divider(),
                    _buildPaymentRow(
                      'Total:',
                      _calculateTotal(widget.product.price),
                      isBold: true,
                    ),
                    SizedBox(height: ResponsiveGap.xl),
                  ],
                ),
              ),
              // Select Card
              Text(
                'Select card',
                style: TextStyle(
                  fontSize: ResponsiveFontSize.lg,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C3C3C),
                ),
              ),
              SizedBox(height: ResponsiveGap.md),

              // Cards Row
              SizedBox(
                height: 25.hp,
                child: Obx(() {
                  final userName = accountController.name.value.isNotEmpty
                      ? accountController.name.value.toUpperCase()
                      : 'CARD HOLDER';

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCreditCard(
                        index: 0,
                        color: Color(0xff7986CB),
                        name: userName,
                        expiry: '12/28',
                      ),
                      SizedBox(width: 4.wp),
                      _buildCreditCard(
                        index: 1,
                        color: Color(0xffEF9A9A),
                        name: userName,
                        expiry: '06/25',
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // CVV Input
              Row(
                children: [
                  Text(
                    'Enter CVV:',
                    style: TextStyle(
                      fontSize: ResponsiveFontSize.md,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                  SizedBox(width: ResponsiveGap.md),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffDEDEDE),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.wp,
                          vertical: 2.hp,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveGap.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: // Pay Now Button
      Container(
        width: double.infinity,
        height: ResponsiveButtonSize.height,
        decoration: BoxDecoration(color: Color(0xffFF5A5F)),
        child: ElevatedButton(
          onPressed: () {
            if (cvvController.text.length == 3) {
              Get.to(() => OrderConfirmationScreen(product: widget.product));
            } else {
              Get.snackbar('Error', 'Please enter valid CVV');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveBorderRadius.small),
            ),
          ),
          child: Text(
            'Pay now',
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

  Widget _buildProgressIndicator({required int currentStep}) {
    return Row(
      children: [
        _buildProgressDot(isActive: true, isFilled: true),
        Expanded(child: _buildProgressLine(isActive: true)),
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

  Widget _buildPaymentRow(String label, String value, {bool isBold = false}) {
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

  Widget _buildCreditCard({
    required int index,
    required Color color,
    required String name,
    required String expiry,
  }) {
    final isSelected = selectedCardIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
        });
      },
      child: Stack(
        children: [
          Container(
            width: 70.wp,
            padding: EdgeInsets.all(5.wp),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveBorderRadius.medium,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveFontSize.md,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.wp,
                    vertical: 0.75.hp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      ResponsiveBorderRadius.small,
                    ),
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: ResponsiveIconSize.medium,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveFontSize.xs,
                      ),
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      'XXXX XXXX XXXX 1234',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveFontSize.sm,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 2.hp,
              right: 4.wp,
              child: Container(
                padding: EdgeInsets.all(0.5.wp),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: ResponsiveIconSize.small,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _calculateTotal(String price) {
    final priceValue =
        int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final total = priceValue + 150;
    return '₹ ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
