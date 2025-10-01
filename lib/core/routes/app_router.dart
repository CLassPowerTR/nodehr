import 'package:flutter/material.dart';
import 'package:my_randevu/core/routes/app_routes.dart';
import 'package:my_randevu/features/first_login_app/first_login_screen.dart';
import 'package:my_randevu/features/splash/splash_screen.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.isletmeGirisi:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.musteriGirisi:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.firstOpen:
        return MaterialPageRoute(builder: (_) => const FirstLoginScreen());
      
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
