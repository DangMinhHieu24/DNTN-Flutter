# App Học Tập - Package Module

Package module Flutter cho ứng dụng AI Learning Coach với thiết kế "Mindful Curator".

## Tính năng

- ✨ Màn hình đăng nhập với thiết kế Nordic-Earth
- 🎨 Design System hoàn chỉnh (colors, typography, theme)
- 📱 Responsive layout (mobile + desktop)
- 🔐 Hỗ trợ đa phương thức đăng nhập: Email/Password, Google, Phone
- 🎭 Animations và micro-interactions mượt mà
- ♿ Accessibility support

## Cài đặt

Thêm package vào `pubspec.yaml` của dự án chính:

```yaml
dependencies:
  app_hoctap:
    path: ../app_hoctap  # Đường dẫn đến package này
```

## Sử dụng

### Import package

```dart
import 'package:app_hoctap/app_hoctap.dart';
```

### Sử dụng LoginPage

```dart
import 'package:flutter/material.dart';
import 'package:app_hoctap/app_hoctap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful Curator',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
```

### Sử dụng Theme riêng lẻ

```dart
// Sử dụng colors
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: AppTextStyles.headlineLarge.copyWith(
      color: AppColors.onPrimary,
    ),
  ),
)
```

### Sử dụng Widgets riêng lẻ

```dart
// Custom TextField
CustomTextField(
  label: 'Email',
  placeholder: 'email@example.com',
  icon: Icons.mail_outline,
  controller: emailController,
)

// Gradient Button
GradientButton(
  text: 'Đăng nhập',
  onPressed: () {
    // Handle login
  },
)

// Social Login Button
SocialLoginButton(
  text: 'Google',
  icon: Icons.g_mobiledata,
  onPressed: () {
    // Handle Google login
  },
)
```

## Cấu trúc Package

```
lib/
├── app_hoctap.dart              # Entry point, exports tất cả
├── core/
│   └── theme/
│       ├── app_colors.dart      # Nordic-Earth color palette
│       ├── app_text_styles.dart # Be Vietnam Pro typography
│       └── app_theme.dart       # Material Theme configuration
└── features/
    └── auth/
        └── presentation/
            ├── pages/
            │   └── login_page.dart
            └── widgets/
                ├── organic_background.dart
                ├── branding_section.dart
                ├── custom_text_field.dart
                ├── gradient_button.dart
                └── social_login_button.dart
```

## Yêu cầu

- Flutter SDK: >=3.0.0 <4.0.0
- Font: Be Vietnam Pro (cần thêm vào assets)

## Font Setup

Download font Be Vietnam Pro từ [Google Fonts](https://fonts.google.com/specimen/Be+Vietnam+Pro) và đặt vào thư mục `assets/fonts/`:

- BeVietnamPro-Regular.ttf (400)
- BeVietnamPro-Medium.ttf (500)
- BeVietnamPro-Bold.ttf (700)
- BeVietnamPro-ExtraBold.ttf (800)

## Design System

Package này tuân thủ design system "Mindful Curator" với:

- **Colors**: Nordic-Earth palette với 40+ color tokens
- **Typography**: Be Vietnam Pro với 4 weights
- **Border Radius**: 16px (default), 32px (lg), 48px (xl), full (9999px)
- **Principles**: No hard borders, ambient shadows, organic shapes

## License

Private package for AI Learning Coach project.
