import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/presentation/screen/auth/get_start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: const GetStartScreen(),
    );
  }
}
