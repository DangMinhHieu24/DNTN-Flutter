import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/app_colors.dart';
import 'package:core/theme/app_text_styles.dart';
import 'package:core/theme/app_dimensions.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          // Navigate back to login khi logout
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Text(
                'Mindful Curator',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.onSurface),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Đăng xuất'),
                    content: const Text('Bạn có chắc muốn đăng xuất?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.read<AuthBloc>().add(const LogoutRequested());
                        },
                        child: const Text('Đăng xuất'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacing2XL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing3XL),
                      Text(
                        'Chào mừng trở lại!',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      Text(
                        state.user.name,
                        style: AppTextStyles.displaySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingS),
                      Text(
                        state.user.phone,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing5XL),
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spacing2XL),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.cardBorderRadiusMedium,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.celebration_rounded,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: AppDimensions.spacingL),
                            Text(
                              'Đăng nhập thành công!',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingS),
                            Text(
                              'Bạn đã đăng nhập vào hệ thống.\nTrang chủ đang được phát triển...',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
