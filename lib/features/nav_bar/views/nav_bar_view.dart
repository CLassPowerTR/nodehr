import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
import 'package:nodehr/core/constants/app_radius.dart';
import 'package:nodehr/core/constants/app_strings.dart';
import 'package:nodehr/features/home/views/home_view.dart';
import 'package:nodehr/features/profile/views/profile_view.dart';
import 'package:nodehr/core/constants/app_colors.dart';
import 'package:nodehr/core/constants/app_text_styles.dart';

class NavBarView extends StatefulWidget {
  final int initialIndex;
  const NavBarView({super.key, this.initialIndex = 0});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  late int _currentIndex = widget.initialIndex;

  final List<Widget> _pages = const [HomeView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          padding: AppPaddings.all12,
          decoration: const BoxDecoration(color: AppColors.background),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 0),
                  borderRadius: AppRadius.r12,
                  child: Container(
                    height: 48,
                    padding: AppPaddings.h12,
                    decoration: BoxDecoration(
                      gradient: _currentIndex == 0
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: _currentIndex == 0 ? null : Colors.transparent,
                      borderRadius: AppRadius.r42,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.navBarHome,
                          style: AppTextStyles.navBarTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 1),
                  borderRadius: AppRadius.r12,
                  child: Container(
                    height: 48,
                    padding: AppPaddings.navBarItemPadding,
                    decoration: BoxDecoration(
                      gradient: _currentIndex == 1
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: _currentIndex == 1 ? null : Colors.transparent,
                      borderRadius: AppRadius.r42,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _currentIndex == 1
                              ? Icons.person
                              : Icons.person_outline,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.profile,
                          style: AppTextStyles.navBarTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
