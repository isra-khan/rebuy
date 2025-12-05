import 'package:rebuyproject/utils/responsive.dart';

// Responsive padding constants
class ResponsivePadding {
  // Horizontal padding
  static double get pageHorizontal => 6.wp;  // ~24px on most phones
  static double get cardHorizontal => 3.wp;   // ~12px
  static double get small => 2.wp;            // ~8px
  static double get medium => 4.wp;           // ~16px
  static double get large => 6.wp;            // ~24px
  
  // Vertical padding
  static double get pageVertical => 2.hp;     // ~16px
  static double get cardVertical => 1.5.hp;   // ~12px
  static double get smallV => 1.hp;           // ~8px
  static double get mediumV => 2.hp;          // ~16px
  static double get largeV => 3.hp;           // ~24px
}

// Responsive icon sizes
class ResponsiveIconSize {
  static double get small => 5.wp;      // ~20px
  static double get medium => 6.wp;     // ~24px
  static double get large => 7.wp;      // ~28px
  static double get xlarge => 10.wp;    // ~40px
}

// Responsive border radius
class ResponsiveBorderRadius {
  static double get small => 2.wp;      // ~8px
  static double get medium => 3.wp;     // ~12px
  static double get large => 5.wp;      // ~20px
  static double get circular => 50.wp;  // For circles
}

// Responsive card dimensions
class ResponsiveCardSize {
  static double get productCardWidth => 67.5.wp;    // ~270px
  static double get productCardHeight => 32.5.hp;   // ~260px
  static double get avatarRadius => 7.5.wp;         // ~30px
  static double get avatarLarge => 12.5.wp;         // ~50px
}

// Responsive button sizes
class ResponsiveButtonSize {
  static double get height => 7.hp;              // ~56-70px
  static double get width => double.infinity;
  static double get heightSmall => 5.hp;         // ~40px
  static double get heightLarge => 8.hp;         // ~64px
}

// Responsive spacing between elements
class ResponsiveGap {
  static double get xs => 0.5.hp;      // ~4px
  static double get sm => 1.hp;        // ~8px
  static double get md => 1.5.hp;      // ~12px
  static double get lg => 2.hp;        // ~16px
  static double get xl => 3.hp;        // ~24px
  static double get xxl => 4.hp;       // ~32px
}

