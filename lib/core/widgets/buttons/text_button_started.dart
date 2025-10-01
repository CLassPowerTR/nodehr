import 'package:flutter/material.dart';
import 'package:my_randevu/core/constants/app_colors.dart';
import 'package:my_randevu/core/constants/app_paddings.dart';
import 'package:my_randevu/core/constants/app_radius.dart';
import 'package:my_randevu/core/constants/app_text_styles.dart';

TextButton textButtonStarted(
  BuildContext context,
  String text,
  VoidCallback onPressed, {
  Color? textColor,
  Color? backgroundColor,
  double? fontSize,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: padding ?? AppPaddings.all8,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? AppRadius.r16,
      ),
    ),
    child: Text(
      text,
      style: AppTextStyle.bodyMediumBold(
        context,
        color: textColor ?? AppColors.textColor(context),
      ),
    ),
  );
}
