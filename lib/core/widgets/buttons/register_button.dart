import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_colors.dart';
import 'package:nodehr/core/constants/app_radius.dart';
import 'package:nodehr/core/constants/app_strings.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final bool isLoading;

  const RegisterButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.r16),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Text(AppStrings.register),
      ),
    );
  }
}
