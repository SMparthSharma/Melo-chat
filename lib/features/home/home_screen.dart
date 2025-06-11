import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/features/auth/presentation/screen/auth/login_screen.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          getIt<AppRouter>().pushAndRemoveUntil(LoginScreen());
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                await getIt<AuthCubit>().signOut();
              },
              child: const Text('signout'),
            ),
          ),
        );
      },
    );
  }
}
