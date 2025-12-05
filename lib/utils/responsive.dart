import 'package:flutter/material.dart';

class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;
  
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double _safeBlockHorizontal;
  static late double _safeBlockVertical;
  
  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;
  
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    _safeAreaHorizontal = _blockSizeHorizontal * 100;
    _safeAreaVertical = _blockSizeVertical * 100;
    _safeBlockHorizontal = (_safeAreaHorizontal) / 100;
    _safeBlockVertical = (_safeAreaVertical) / 100;

    textMultiplier = _safeBlockVertical;
    imageSizeMultiplier = _safeBlockHorizontal;
    heightMultiplier = _safeBlockVertical;
    widthMultiplier = _safeBlockHorizontal;
  }
}

// Extension methods for easy responsive sizing
extension ResponsiveSize on num {
  // Width percentage of screen
  double get wp => Responsive.widthMultiplier * this;
  
  // Height percentage of screen  
  double get hp => Responsive.heightMultiplier * this;
  
  // Font size
  double get sp => Responsive.textMultiplier * this;
  
  // Image size
  double get ip => Responsive.imageSizeMultiplier * this;
}

// Responsive spacing utilities
class ResponsiveSpacing {
  // Horizontal spacing
  static double get xs => 4.wp;
  static double get sm => 8.wp;
  static double get md => 12.wp;
  static double get lg => 16.wp;
  static double get xl => 24.wp;
  static double get xxl => 32.wp;
  
  // Vertical spacing
  static double get xsV => 4.hp;
  static double get smV => 8.hp;
  static double get mdV => 12.hp;
  static double get lgV => 16.hp;
  static double get xlV => 24.hp;
  static double get xxlV => 32.hp;
}

// Responsive font sizes
class ResponsiveFontSize {
  static double get xs => 1.2.sp;      // ~12px
  static double get sm => 1.4.sp;      // ~14px
  static double get md => 1.6.sp;      // ~16px
  static double get lg => 1.8.sp;      // ~18px
  static double get xl => 2.0.sp;      // ~20px
  static double get xxl => 2.4.sp;     // ~24px
  static double get xxxl => 2.8.sp;    // ~28px
  static double get heading => 3.2.sp; // ~32px
}

// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 450;
  static const double tablet = 768;
  static const double desktop = 1024;
  
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < mobile;
      
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= mobile && 
      MediaQuery.of(context).size.width < desktop;
      
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= desktop;
}

// Responsive widget wrapper
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Responsive().init(constraints, orientation);
            return builder(context, constraints);
          },
        );
      },
    );
  }
}

