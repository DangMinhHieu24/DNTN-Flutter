import 'package:flutter/material.dart';
import 'package:core/theme/app_colors.dart';
import 'package:core/theme/app_text_styles.dart';
import 'package:core/theme/app_dimensions.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? imageUrl;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    this.icon,
    this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.socialButtonHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.socialButtonBorderRadius),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.socialButtonBorderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (text == 'Google')
                  const Icon(
                    Icons.g_mobiledata_rounded,
                    color: AppColors.onSurface,
                    size: 30,
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: AppColors.onSurface,
                    size: AppDimensions.iconSmall,
                  )
                else if (imageUrl != null)
                  const Icon(
                    Icons.public,
                    color: AppColors.onSurface,
                    size: AppDimensions.iconSmall,
                  ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  text,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
