# Responsive Design Guide

## ✅ Setup Complete!

Your app now has a complete responsive system set up. Here's how to use it:

## 📁 Files Created:

1. **`lib/utils/responsive.dart`** - Core responsive utilities
2. **`lib/utils/responsive_constants.dart`** - Predefined responsive constants
3. **`lib/main.dart`** - Updated with `ResponsiveBuilder`

## 🎯 How to Use Responsive Design

### 1. **Responsive Sizing Extensions**

```dart
import 'package:rebuyproject/utils/responsive.dart';

// Width percentage (% of screen width)
Container(
  width: 50.wp,  // 50% of screen width
  height: 25.hp, // 25% of screen height
)

// Font sizes
Text(
  'Hello',
  style: TextStyle(fontSize: 2.sp), // ~20px responsive
)

// Image sizes
CircleAvatar(
  radius: 7.5.wp, // ~30px responsive
)
```

### 2. **Using Predefined Constants**

```dart
import 'package:rebuyproject/utils/responsive_constants.dart';

// Padding
Padding(
  padding: EdgeInsets.all(ResponsivePadding.large),
  child: ...
)

// Font sizes
Text(
  'Title',
  style: TextStyle(fontSize: ResponsiveFontSize.xl),
)

// Gaps/Spacing
SizedBox(height: ResponsiveGap.lg),

// Border radius
BorderRadius.circular(ResponsiveBorderRadius.medium),

// Icon sizes
Icon(Icons.home, size: ResponsiveIconSize.medium),
```

### 3. **Converting Existing Fixed Values**

#### **Before (Fixed):**
```dart
Padding(
  padding: EdgeInsets.all(24.0),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 28),
  ),
)
```

#### **After (Responsive):**
```dart
Padding(
  padding: EdgeInsets.all(6.wp), // or ResponsivePadding.large
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 3.5.sp), // or ResponsiveFontSize.xxxl
  ),
)
```

### 4. **Responsive Breakpoints**

```dart
import 'package:rebuyproject/utils/responsive.dart';

Widget build(BuildContext context) {
  if (ResponsiveBreakpoints.isMobile(context)) {
    return MobileLayout();
  } else if (ResponsiveBreakpoints.isTablet(context)) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

### 5. **Common Conversions**

| Fixed Value | Responsive | Constant |
|------------|-----------|----------|
| `padding: 24` | `6.wp` | `ResponsivePadding.large` |
| `padding: 16` | `4.wp` | `ResponsivePadding.medium` |
| `padding: 8` | `2.wp` | `ResponsivePadding.small` |
| `fontSize: 28` | `3.5.sp` | `ResponsiveFontSize.xxxl` |
| `fontSize: 24` | `3.sp` | `ResponsiveFontSize.xxl` |
| `fontSize: 18` | `2.25.sp` | `ResponsiveFontSize.lg` |
| `fontSize: 16` | `2.sp` | `ResponsiveFontSize.md` |
| `fontSize: 14` | `1.75.sp` | `ResponsiveFontSize.sm` |
| `height: 70` | `8.75.hp` | `ResponsiveButtonSize.height` |
| `width: 270` | `67.5.wp` | `ResponsiveCardSize.productCardWidth` |
| `radius: 30` | `7.5.wp` | `ResponsiveCardSize.avatarRadius` |
| `SizedBox(height: 16)` | `SizedBox(height: 2.hp)` | `ResponsiveGap.lg` |

## 📱 Example: Making HomeScreen Responsive

### Current (Fixed):
```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0),
  child: Text(
    'Hey ${controller.userName.value}',
    style: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### Responsive Version:
```dart
Padding(
  padding: EdgeInsets.symmetric(horizontal: ResponsivePadding.pageHorizontal),
  child: Text(
    'Hey ${controller.userName.value}',
    style: TextStyle(
      fontSize: ResponsiveFontSize.xxxl,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

## 🎨 Quick Reference

### Padding Values:
- **Small**: `ResponsivePadding.small` (8px)
- **Medium**: `ResponsivePadding.medium` (16px)
- **Large**: `ResponsivePadding.large` (24px)
- **Page**: `ResponsivePadding.pageHorizontal` (24px)

### Font Sizes:
- **XS**: `ResponsiveFontSize.xs` (12px)
- **SM**: `ResponsiveFontSize.sm` (14px)
- **MD**: `ResponsiveFontSize.md` (16px)
- **LG**: `ResponsiveFontSize.lg` (18px)
- **XL**: `ResponsiveFontSize.xl` (20px)
- **XXL**: `ResponsiveFontSize.xxl` (24px)
- **XXXL**: `ResponsiveFontSize.xxxl` (28px)
- **Heading**: `ResponsiveFontSize.heading` (32px)

### Gaps:
- **XS**: `ResponsiveGap.xs` (4px)
- **SM**: `ResponsiveGap.sm` (8px)
- **MD**: `ResponsiveGap.md` (12px)
- **LG**: `ResponsiveGap.lg` (16px)
- **XL**: `ResponsiveGap.xl` (24px)
- **XXL**: `ResponsiveGap.xxl` (32px)


Your app is now ready for responsive design! 🎉

