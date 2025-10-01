import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_randevu/core/enums/app/app_local_storage.dart';
import 'package:my_randevu/core/enums/assets/app_images.dart';
import 'package:my_randevu/core/routes/app_router.dart';
import 'package:my_randevu/core/routes/app_routes.dart';

part 'views/splash_view_body.dart';
part 'functions/check_connection.dart';
part 'functions/dontenvLoader.dart';
part 'widgets/image.dart';
part 'widgets/circularProgressIndicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const _SplashViewBody());
  }
}
