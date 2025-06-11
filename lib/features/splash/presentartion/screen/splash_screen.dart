import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/features/auth/presentation/screen/auth/get_start_screen.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void wait(Widget screen) async {
    await Future.delayed(Duration(seconds: 2));
    getIt<AppRouter>().pushReplacement(screen);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          wait(HomeScreen());
        } else {
          wait(GetStartScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(body: Center(child: Icon(Icons.chat, size: 50)));
      },
    );
  }
}
