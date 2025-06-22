import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/presentation/auth/get_start_page.dart';
import 'package:chat_app/presentation/home/home_page.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
          wait(HomePage());
        } else {
          wait(GetStartPage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(child: Image.asset('assets/image/melo_logo.png')),
        );
      },
    );
  }
}
