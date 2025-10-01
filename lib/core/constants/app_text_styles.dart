import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_randevu/core/constants/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  // Headers
  static TextStyle header(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle headerPrimary(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle headerSecondary(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.secondary(context),
    );
  }

  // Titles
  static TextStyle title(
    BuildContext context, {
    Color? color,
    TextStyle? size,
  }) {
    final style = Theme.of(context).textTheme;
    TextStyle baseStyle = size ?? style.titleMedium!;
    return baseStyle.copyWith(color: color ?? AppColors.textColor(context));
  }

  static TextStyle titleBold(
    BuildContext context, {
    Color? color,
    TextStyle? size,
  }) {
    final style = Theme.of(context).textTheme;
    TextStyle baseStyle = size ?? style.titleMedium!;
    return baseStyle.copyWith(
      color: color ?? AppColors.textColor(context),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle titleMuted(
    BuildContext context, {
    Color? color,
    TextStyle? size,
  }) {
    final style = Theme.of(context).textTheme;
    TextStyle baseStyle = size ?? style.titleMedium!;
    return baseStyle.copyWith(color: color ?? AppColors.mutedColor(context));
  }

  // Subtitles
  static TextStyle subtitle(
    BuildContext context, {
    Color? color,
    TextStyle? size,
  }) {
    final style = Theme.of(context).textTheme;
    TextStyle baseStyle = size ?? style.titleSmall!;
    return baseStyle.copyWith(color: color ?? AppColors.textColor(context));
  }

  static TextStyle subtitleMuted(
    BuildContext context, {
    Color? color,
    TextStyle? size,
    FontWeight? weight,
  }) {
    final style = Theme.of(context).textTheme;
    TextStyle baseStyle = size ?? style.titleSmall!;
    return baseStyle.copyWith(
      fontWeight: weight ?? FontWeight.w500,
      color: color ?? AppColors.mutedColor(context),
    );
  }

  static TextStyle subtitleBold(
    BuildContext context, {
    Color? color,
    TextStyle? size,
  }) {
    final style = Theme.of(context).textTheme;
    TextStyle baseStyle = size ?? style.titleSmall!;
    return baseStyle.copyWith(
      color: color ?? AppColors.textColor(context),
      fontWeight: FontWeight.bold,
    );
  }

  // Body
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodyMedium!.copyWith(
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle bodyMediumBold(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodyMedium!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle bodyMediumMuted(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodyMedium!.copyWith(
      color: color ?? AppColors.mutedColor(context),
      fontWeight: FontWeight.w400,
    );
  }

  // Body
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodySmall!.copyWith(
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle bodySmallBold(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodySmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle bodySmallMuted(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodySmall!.copyWith(
      color: color ?? AppColors.mutedColor(context),
      fontWeight: FontWeight.w400,
    );
  }

  // Body
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodyLarge!.copyWith(
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle bodyLargeBold(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodyLarge!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textColor(context),
    );
  }

  static TextStyle bodyLargeMuted(BuildContext context, {Color? color}) {
    final style = Theme.of(context).textTheme;
    return style.bodyLarge!.copyWith(
      color: color ?? AppColors.mutedColor(context),
      fontWeight: FontWeight.w400,
    );
  }
}
