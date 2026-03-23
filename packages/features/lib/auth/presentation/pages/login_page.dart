import 'package:flutter/material.dart';
import 'package:core/theme/app_colors.dart';
import 'package:core/theme/app_text_styles.dart';
import 'package:core/widgets/widgets.dart';
import '../widgets/widgets.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;

    return Scaffold(
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
                        horizontal: isDesktop ? 64 : 24,
                        vertical: 40,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(flex: 12, child: BrandingSection()),
                                  const Spacer(flex: 2),
                                  Expanded(flex: 10, child: _buildLoginForm(context)),
                                ],
                              )
                            : _buildLoginForm(context),
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
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chào mừng bạn\ntrở lại',
            textAlign: TextAlign.center,
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.1,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tiếp tục hành trình chinh phục tri thức\ncùng trợ lý AI của riêng bạn.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          CustomTextField(
            label: 'EMAIL',
            placeholder: 'email@example.com',
            icon: Icons.mail_outline_rounded,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MẬT KHẨU',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Quên mật khẩu?',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          GradientButton(
            text: 'Đăng nhập',
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'HOẶC TIẾP TỤC VỚI',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.outline.withValues(alpha: 0.4),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SocialLoginButton(
                  text: 'Google',
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SocialLoginButton(
                  text: 'Số điện thoại',
                  icon: Icons.smartphone_rounded,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            '© 2024 AI LEARNING COACH.\nCURATED FOCUS.',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              letterSpacing: 2.0,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có tài khoản? ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Text(
                    'Đăng ký ngay',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
