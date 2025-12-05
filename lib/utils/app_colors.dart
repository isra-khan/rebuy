import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF3C3C3C);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color inputBackground = Color(
    0xFFE0E0E0,
  ); // Light grey for inputs
  static const Color socialButtonBackground = Color(0xFFE0E0E0);

  // Gradient Colors from Splash Screen
  static const Color gradientStart = Color(0xffFF5A5F);
  static const Color gradientEnd = Color(0xffC1839F);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
