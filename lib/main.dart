import 'package:flutter/material.dart';
import 'package:my_randevu/core/constants/app_strings.dart';
import 'package:my_randevu/core/routes/app_router.dart';
import 'package:my_randevu/core/routes/app_routes.dart';
import 'package:my_randevu/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp(
      onGenerateTitle: (context) => AppStrings.appName,
      theme: AppTheme.light(context),
      darkTheme: AppTheme.dark(context),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        //AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      onGenerateRoute: appRouter.onGenerateRoute,
      initialRoute: AppRoutes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
