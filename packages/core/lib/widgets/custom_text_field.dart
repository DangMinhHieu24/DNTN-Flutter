import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.errorText,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: suffixIcon,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
