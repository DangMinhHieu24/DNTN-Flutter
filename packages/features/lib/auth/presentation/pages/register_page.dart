import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/app_colors.dart';
import 'package:core/theme/app_text_styles.dart';
import 'package:core/theme/app_dimensions.dart';
import 'package:core/widgets/widgets.dart';
import '../widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    if (value.trim().length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Remove spaces and check if it's a valid Vietnamese phone number
    final phone = value.replaceAll(' ', '');
    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }
    if (value != _passwordController.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // Dispatch RegisterRequested event
      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim().replaceAll(' ', ''),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppDimensions.desktopBreakpoint;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navigate to Home page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            const OrganicBackground(),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop 
                            ? AppDimensions.pagePaddingDesktop 
                            : AppDimensions.pagePaddingMobile,
                          vertical: AppDimensions.pagePaddingVertical,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AppDimensions.formMaxWidth,
                          ),
                          child: isDesktop
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(flex: 12, child: BrandingSection()),
                                    const Spacer(flex: 2),
                                    Expanded(flex: 10, child: _buildRegisterForm(context)),
                                  ],
                                )
                              : _buildRegisterForm(context),
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(context, isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.formPaddingHorizontal,
              vertical: AppDimensions.formPaddingVertical,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppDimensions.formBorderRadius),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
                width: AppDimensions.formBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: AppDimensions.shadowBlurHeavy,
                  offset: const Offset(0, AppDimensions.shadowOffsetHeavy),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          // Header with Logo and Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.psychology_alt_rounded,
                    color: AppColors.primary,
                    size: AppDimensions.iconMedium,
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    'AI Learning Coach',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing4XL),
          Text(
            'Bắt đầu hành trình\ncủa bạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 32,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Kiến tạo tương lai cùng trí tuệ nhân tạo',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
                const SizedBox(height: AppDimensions.spacing4XL),
                CustomTextField(
                  label: 'Họ tên',
                  placeholder: 'Nguyễn Văn A',
                  icon: Icons.person_outline_rounded,
                  controller: _nameController,
                  validator: _validateName,
                  onChanged: (value) {
                    // Trigger validation on change
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                CustomTextField(
                  label: 'Số điện thoại',
                  placeholder: '0901234567',
                  icon: Icons.phone_android_rounded,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                CustomTextField(
                  label: 'Mật khẩu',
                  placeholder: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                CustomTextField(
                  label: 'Nhập lại mật khẩu',
                  placeholder: '••••••••',
                  icon: Icons.lock_reset_rounded,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: _validateConfirmPassword,
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.spacing3XL),
                GradientButton(
                  text: 'Đăng ký ngay',
                  onPressed: isLoading ? () {} : _handleRegister,
                  isLoading: isLoading,
                ),
          const SizedBox(height: AppDimensions.spacing3XL),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                ),
                child: Text(
                  'HOẶC TIẾP TỤC VỚI',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.outline.withValues(alpha: 0.4),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing2XL),
          Row(
            children: [
              Expanded(
                child: SocialLoginButton(
                  text: 'Google',
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppDimensions.spacingL),
              Expanded(
                child: SocialLoginButton(
                  text: 'Số điện thoại',
                  icon: Icons.smartphone_rounded,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing4XL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Đã có tài khoản? ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Đăng nhập ngay',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.footerPadding),
      child: Column(
        children: [
          Text(
            '© 2024 AI LEARNING COACH.\nNÂNG TẦM TRI THỨC MỖI NGÀY.',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              letterSpacing: 1.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterItem('PRIVACY'),
              _buildFooterDot(),
              _buildFooterItem('TERMS'),
              _buildFooterDot(),
              _buildFooterItem('SUPPORT'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterDot() {
    return Container(
      width: AppDimensions.footerDotSize,
      height: AppDimensions.footerDotSize,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.footerDotMargin,
      ),
      decoration: BoxDecoration(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFooterItem(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            letterSpacing: 1.5,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
