import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
import 'package:nodehr/core/constants/app_strings.dart';
import 'package:nodehr/core/constants/app_text_styles.dart';
import 'package:nodehr/core/mixins/validators_mixin.dart';
import 'package:nodehr/core/api/services/api_service.dart';
import 'package:nodehr/core/widgets/buttons/primary_button.dart';
import 'package:nodehr/core/widgets/buttons/register_button.dart';
import 'package:nodehr/core/widgets/text_form_field/app_text_form_field.dart';
import 'package:nodehr/core/routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidatorsMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ApiService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      print(e);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.all16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Center(child: SizedBox(height: 160, child: _buildLottie())),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                AppStrings.login,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: _emailController,
                      labelText: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    AppTextFormField(
                      controller: _passwordController,
                      labelText: AppStrings.password,
                      obscureText: true,
                      validator: validatePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                onPressed: _isLoading ? null : _onSubmit,
                label: AppStrings.login,
                isLoading: _isLoading,
              ),
              Text(
                AppStrings.or,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              RegisterButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.register);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLottie() {
    // Yerel PNG ikonunu göster; bulunamazsa bir ikon ile devam et
    try {
      return Image.asset('assets/icons/AppIcon.png', fit: BoxFit.contain);
    } catch (_) {
      return const Icon(Icons.movie, size: 96);
    }
  }
}
