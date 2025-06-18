import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/presentation/splash/splash_page.dart';
import 'package:chat_app/data/service/service_locator.dart';
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
      home: const SplashPage(),
    );
  }
}
