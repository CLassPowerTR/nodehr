import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_radius.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
import 'package:nodehr/core/constants/app_text_styles.dart';
import 'package:nodehr/core/constants/app_colors.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;

  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.textInputAction,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late final FocusNode _focusNode;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscure = widget.obscureText;
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool focused = _focusNode.hasFocus;

    return SizedBox(
      height: 89,
      child: TextFormField(
        textInputAction: widget.textInputAction,
        controller: widget.controller,
        focusNode: _focusNode,

        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: _obscure,
        style: focused ? AppTextStyles.body1 : AppTextStyles.body,
        cursorColor: focused
            ? AppTextStyles.body1.color
            : AppTextStyles.body.color,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: focused ? AppTextStyles.body1 : AppTextStyles.body,
          hintStyle: focused ? AppTextStyles.body1 : AppTextStyles.body,
          prefixIcon: widget.prefixIcon == null
              ? null
              : IconTheme(
                  data: IconThemeData(
                    color: focused
                        ? AppTextStyles.body1.color
                        : AppTextStyles.body.color,
                  ),
                  child: widget.prefixIcon!,
                ),
          // Reserve space for helper/error text so the input area does not
          // shrink when an error message appears.
          helperText: ' ',
          helperStyle: AppTextStyles.body,
          errorStyle: AppTextStyles.body.copyWith(color: AppColors.error),
          contentPadding: AppPaddings.textFormFieldPadding,
          border: OutlineInputBorder(
            borderRadius: AppRadius.r18,
            borderSide: const BorderSide(width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.r18,
            borderSide: const BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.r18,
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.r18,
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppRadius.r18,
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: focused
                        ? AppTextStyles.body1.color
                        : AppTextStyles.body.color,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
