import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/features/splash/presentartion/screen/splash_screen.dart';
import 'package:chat_app/service_locator.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<AppRouter>().navigatorKey,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
