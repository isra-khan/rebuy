import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rebuyproject/controllers/signup_controller.dart';
import 'package:rebuyproject/utils/app_colors.dart';
import 'package:rebuyproject/utils/app_icons.dart';
import 'package:rebuyproject/utils/responsive.dart';
import 'package:rebuyproject/utils/responsive_constants.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

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
              // Top Bar
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
                        color: Color(0xff555555),
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
                ],
              ),
              SizedBox(height: 5.hp),

              // Title
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 6.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C3C3C),
                ),
              ),
              SizedBox(height: 1.5.hp),
              Text(
                'Sign Up  with one of the following options',
                style: TextStyle(
                  color: Color(0xff828282),
                  fontSize: ResponsiveFontSize.sm,
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSocialButton(
                    child: SvgPicture.string(
                      AppIcons.google,
                      height: ResponsiveIconSize.medium,
                    ),
                  ),
                  _buildSocialButton(
                    child: SvgPicture.string(
                      AppIcons.twitter,
                      height: ResponsiveIconSize.medium,
                    ),
                  ),
                  _buildSocialButton(
                    child: SvgPicture.string(
                      AppIcons.apple,
                      height: ResponsiveIconSize.medium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveGap.xxl),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Color(0xff828282))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.wp),
                    child: Text(
                      'Or',
                      style: TextStyle(
                        color: Color(0xff828282),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xff828282))),
                ],
              ),
              SizedBox(height: ResponsiveGap.xxl),

              // Inputs
              _buildTextField(
                controller: controller.nameController,
                label: 'Name',
                hint: 'Enter your name',
              ),
              SizedBox(height: ResponsiveGap.lg),
              _buildTextField(
                controller: controller.emailController,
                label: 'Email',
                hint: 'Enter your email',
                isPassword: false,
              ),
              SizedBox(height: ResponsiveGap.lg),
              _buildTextField(
                controller: controller.passwordController,
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
              ),
              SizedBox(height: ResponsiveGap.lg),
              _buildTextField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Enter your password',
                isPassword: true,
              ),
              SizedBox(height: ResponsiveGap.xxl),

              // Login Button
              Container(
                width: double.infinity,
                height: ResponsiveButtonSize.height,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(
                    ResponsiveBorderRadius.medium,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientStart.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveBorderRadius.medium,
                      ),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: ResponsiveFontSize.lg,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveGap.xl),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Color(0xff8D8D8D),
                      fontSize: ResponsiveFontSize.sm,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignupScreen());
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.gradientStart,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveFontSize.sm,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required Widget child}) {
    return Expanded(
      child: Container(
        height: 7.5.hp,
        margin: EdgeInsets.symmetric(horizontal: 2.wp),
        decoration: BoxDecoration(
          color: Color(0xffDEDEDE),
          borderRadius: BorderRadius.circular(ResponsiveBorderRadius.large),
          border: Border.all(color: Colors.transparent), // Or border if needed
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffDEDEDE),
        borderRadius: BorderRadius.circular(ResponsiveBorderRadius.medium),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Color(0xff6F6F6F),
            fontSize: ResponsiveFontSize.sm,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 5.wp,
            vertical: 2.hp,
          ),
          labelStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: ResponsiveFontSize.md,
          ),
        ),
      ),
    );
  }
}
