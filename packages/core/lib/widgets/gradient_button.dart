import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_dimensions.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark, // Sử dụng sắc độ đậm hơn để tạo chiều sâu
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.2 : 0.1),
                blurRadius: _isHovered 
                  ? AppDimensions.shadowBlurMedium 
                  : AppDimensions.shadowBlurLight,
                offset: Offset(
                  0,
                  _isHovered 
                    ? AppDimensions.shadowOffsetMedium 
                    : AppDimensions.shadowOffsetLight,
                ),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.text,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
