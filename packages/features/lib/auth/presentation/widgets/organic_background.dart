import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:core/theme/app_colors.dart';

class OrganicBackground extends StatelessWidget {
  const OrganicBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -MediaQuery.of(context).size.height * 0.1,
          left: -MediaQuery.of(context).size.width * 0.1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -MediaQuery.of(context).size.height * 0.1,
          right: -MediaQuery.of(context).size.width * 0.1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
