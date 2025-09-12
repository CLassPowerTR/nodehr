import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:nodehr/features/splash/views/splash_view.dart';
import 'package:nodehr/features/auth/views/login_view.dart';
import 'package:nodehr/features/auth/views/register_view.dart';
import 'package:nodehr/features/nav_bar/views/nav_bar_view.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const NavBarView());
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const NavBarView(initialIndex: 1),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashView());
    }
  }
}
