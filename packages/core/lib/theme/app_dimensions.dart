class AppDimensions {
  AppDimensions._();

  // ============================================
  // BREAKPOINTS - Điểm chuyển đổi responsive
  // ============================================
  /// Màn hình >= 1024px được coi là desktop
  static const double desktopBreakpoint = 1024;
  
  /// Màn hình >= 768px được coi là tablet
  static const double tabletBreakpoint = 768;

  // ============================================
  // LAYOUT - Kích thước layout chính
  // ============================================
  /// Chiều rộng tối đa của form container
  static const double formMaxWidth = 1100;
  
  /// Padding ngang cho page ở desktop
  static const double pagePaddingDesktop = 64;
  
  /// Padding ngang cho page ở mobile
  static const double pagePaddingMobile = 24;
  
  /// Padding dọc cho page
  static const double pagePaddingVertical = 40;

  // ============================================
  // FORM CONTAINER - Kích thước form đăng nhập/đăng ký
  // ============================================
  /// Padding ngang bên trong form
  static const double formPaddingHorizontal = 40;
  
  /// Padding dọc bên trong form
  static const double formPaddingVertical = 48;
  
  /// Border radius của form container
  static const double formBorderRadius = 48;
  
  /// Độ dày border của form
  static const double formBorderWidth = 1.5;

  // ============================================
  // SPACING - Khoảng cách giữa các elements
  // ============================================
  /// 4px - Spacing cực nhỏ
  static const double spacing2XS = 4;
  
  /// 6px - Spacing rất nhỏ
  static const double spacingXS = 6;
  
  /// 8px - Spacing nhỏ
  static const double spacingS = 8;
  
  /// 12px - Spacing nhỏ-vừa
  static const double spacingM = 12;
  
  /// 16px - Spacing vừa
  static const double spacingL = 16;
  
  /// 20px - Spacing vừa-lớn
  static const double spacingXL = 20;
  
  /// 24px - Spacing lớn
  static const double spacing2XL = 24;
  
  /// 32px - Spacing rất lớn
  static const double spacing3XL = 32;
  
  /// 40px - Spacing cực lớn
  static const double spacing4XL = 40;
  
  /// 48px - Spacing khổng lồ
  static const double spacing5XL = 48;

  // ============================================
  // INPUT FIELDS - TextField dimensions
  // ============================================
  /// Border radius của input field
  static const double inputBorderRadius = 20;
  
  /// Padding ngang bên trong input
  static const double inputPaddingHorizontal = 24;
  
  /// Padding dọc bên trong input
  static const double inputPaddingVertical = 18;

  // ============================================
  // BUTTONS - Kích thước buttons
  // ============================================
  /// Chiều cao của button chính (GradientButton)
  static const double buttonHeight = 56;
  
  /// Border radius của button (9999 = fully rounded)
  static const double buttonBorderRadius = 9999;
  
  /// Chiều cao của social login button
  static const double socialButtonHeight = 54;
  
  /// Border radius của social button
  static const double socialButtonBorderRadius = 20;

  // ============================================
  // ICONS - Kích thước icons
  // ============================================
  /// Icon nhỏ (trong input field)
  static const double iconSmall = 20;
  
  /// Icon vừa (logo, header)
  static const double iconMedium = 28;
  
  /// Icon lớn
  static const double iconLarge = 32;

  // ============================================
  // CARDS & CONTAINERS
  // ============================================
  /// Border radius cho card nhỏ
  static const double cardBorderRadiusSmall = 12;
  
  /// Border radius cho card vừa
  static const double cardBorderRadiusMedium = 24;
  
  /// Border radius cho card lớn
  static const double cardBorderRadiusLarge = 48;

  // ============================================
  // SHADOWS - Độ mờ và offset của shadow
  // ============================================
  /// Blur radius cho shadow nhẹ
  static const double shadowBlurLight = 20;
  
  /// Blur radius cho shadow vừa
  static const double shadowBlurMedium = 30;
  
  /// Blur radius cho shadow nặng
  static const double shadowBlurHeavy = 50;
  
  /// Offset Y cho shadow nhẹ
  static const double shadowOffsetLight = 4;
  
  /// Offset Y cho shadow vừa
  static const double shadowOffsetMedium = 8;
  
  /// Offset Y cho shadow nặng
  static const double shadowOffsetHeavy = 20;

  // ============================================
  // FOOTER
  // ============================================
  /// Padding cho footer
  static const double footerPadding = 40;
  
  /// Kích thước dot trong footer
  static const double footerDotSize = 4;
  
  /// Margin ngang của dot
  static const double footerDotMargin = 16;
}
