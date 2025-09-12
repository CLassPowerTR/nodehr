import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_colors.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
import 'package:nodehr/core/constants/app_strings.dart';
import 'package:nodehr/core/constants/app_text_styles.dart';
import 'package:nodehr/core/mixins/validators_mixin.dart';
import 'package:nodehr/core/widgets/buttons/primary_button.dart';
import 'package:nodehr/core/widgets/text_form_field/app_text_form_field.dart';
import 'package:nodehr/core/routes/app_routes.dart';
import 'package:nodehr/core/api/services/api_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with ValidatorsMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ApiService.register(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      final String message = e.toString().replaceFirst('Exception: ', '');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.register, style: AppTextStyles.h1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.all16,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextFormField(
                  controller: _nameController,
                  labelText: AppStrings.name,
                  validator: validateName,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                AppTextFormField(
                  controller: _emailController,
                  labelText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                AppTextFormField(
                  controller: _passwordController,
                  labelText: AppStrings.password,
                  obscureText: true,
                  textInputAction: TextInputAction.done,

                  validator: validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  onPressed: _isLoading ? null : _onSubmit,
                  label: AppStrings.register,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
