import 'package:flutter/material.dart';
import 'package:nodehr/core/api/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nodehr/core/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Attempt to fetch profile; on success go to home, on error go to login
    () async {
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getString('ShartFlixAccesToken') ?? '');
      try {
        await Future.delayed(const Duration(milliseconds: 800));
        final profiles = await ApiService.getMyProfile();

        if (!mounted) return;
        if (profiles.isNotEmpty) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      } catch (_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SizedBox(height: 160, child: _buildLottie())),
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
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
